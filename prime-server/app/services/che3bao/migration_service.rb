# rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
module Che3bao
  class MigrationService
    def initialize(id)
      @corp = Corp.find(id)
      @corp_owner = @corp.staffs.find_by(boss_tag: 1)

      Che3bao::VehicleImage.to_qiniu
    end

    def execute
      import_company
      import_users

      import_cars
      create_price_tag_template

      Che3bao::CustomerMigrationService.new(@corp.id, @company.id).execute

      clear_redis
      self.class.recount_ages(@company)

      self
    end

    def self.recount_ages(company)
      company.cars.state_out_of_stock_scope.each do |car|
        stock_out_at = car.stock_out_at || Time.zone.now

        age_days = if car.acquired_at
                     Util::Date.date_different(stock_out_at, car.acquired_at)
                   else
                     0
                   end

        car.update_columns(stock_age_days: age_days)
      end
    end

    def import_company
      @company = Company.create!(
        name: @corp.name,
        contact: @corp.contact,
        contact_mobile: @corp.phone,
        acquisition_mobile: @corp.buy_phone,
        sale_mobile: @corp.sale_phone,
        logo: nil,
        note: @corp.other_desc,
        province: @corp.region.parent.region_name,
        city: @corp.region.region_name,
        district: nil,
        street: @corp.address,
        owner_id: nil
      )

      import_shops
      import_channels
      import_warranties
      import_cooperation_companies
      import_mortgage_companies
      import_insurance_companies
      User::RegistrationService.init_intention_levels(@company)
    end

    def import_shops
      @corp.shops.where("status != 2").find_each do |shop|
        new_shop = @company.shops.new(name: shop.locate_name)

        new_shop.save(validate: false)

        shop.appropriate = new_shop
      end
    end

    def import_channels
      @corp.channels.where("valid_tag = 1").find_each do |channel|
        new_channel = @company.channels.new(
          name: channel.source_name,
          note: channel.remark
        )
        new_channel.save(validate: false)

        channel.appropriate = new_channel
      end
    end

    def import_warranties
      @corp.warranties.where("STATUS = 1").find_each do |warranty|
        new_warranty = @company.warranties.new(
          name: warranty.level_name,
          fee_yuan: warranty.warranty_fee.try { |f| f / 100 },
          note: warranty.level_desc
        )
        warranty.save(validate: false)

        warranty.appropriate = new_warranty
      end
    end

    def import_cooperation_companies
      @corp.cooperation_companies.where("valid_tag = 1").find_each do |cc|
        cooperation_company = @company.cooperation_companies.new(
          name: cc.corp_name,
          created_at: cc.create_time,
          updated_at: cc.update_time
        )
        cooperation_company.save(validate: false)

        cc.appropriate = cooperation_company
      end
    end

    def import_mortgage_companies
      @corp.mortgage_companies.where("valid_tag = 1").find_each do |mc|
        mortgage_company = @company.mortgage_companies.new(
          name: mc.corp_name,
          created_at: mc.create_time,
          updated_at: mc.update_time
        )
        mortgage_company.save(validate: false)

        mc.appropriate = mortgage_company
      end
    end

    def import_insurance_companies
      @corp.insurance_companies.where("valid_tag = 1").find_each do |ic|
        insurance_company = @company.insurance_companies.new(
          name: ic.corp_name,
          created_at: ic.create_time,
          updated_at: ic.update_time
        )
        insurance_company.save(validate: false)
        ic.appropriate = insurance_company
      end
    end

    def import_users
      @corp.staffs.find_each do |staff|
        user = User.new(
          name: staff.name,
          username: staff.login_name,
          password: staff.password,
          email: staff.email,
          phone: staff.tel,
          state: staff.status.to_i == 1 ? "enabled" : "disabled",
          is_alliance_contact: staff.alliance_tag.to_i == 1,
          company_id: @company.id,
          manager_id: nil,
          note: staff.remark,
          avatar: nil
        )
        user.save(validate: false)
        staff.appropriate = user

        self.company_owner = user if @corp_owner == staff
      end

      set_manager_ids
    end

    def import_cars
      @corp.stocks.includes(
        { vehicle: [
          :vehicle_images, :acquisition_transfer_images, :vehicle_attach_relationships
        ]
        }, :buy_staff_user, :acquisition_transfer, :channel, :warranty,
        car_reservations: [{ region: :parent }, :channel, :seller],
        sale_transfer: [
          { region: :parent },
          :channel, :seller, :insurance_company, :mortgage_company
        ]
      ).find_each do |stock|
        Car.transaction do
          create_car(stock)

          import_reservations(stock)
        end
      end

      car_ids = @corp.stocks.where("stock_state = 1").map(&:appropriate_id)
      @company.cars.state_in_stock_scope.where.not(id: car_ids).destroy_all
    end

    def create_car(stock)
      @car = Car.where(company_id: @company.id).new(car_params(stock))
      @car.name = @car.make_system_name
      @car.system_name = @car.name
      @car.save(validate: false)

      @car.build_acquisition_transfer(
        acquisition_transfer_params(stock).merge(
          user_id: @car.acquirer_id,
          vin: @car.vin,
          compulsory_insurance: stock.vehicle.issur_valid_tag.to_i == 1,
          commercial_insurance: stock.vehicle.comm_issur_valid_tag.to_i == 1
        )
      ).save(validate: false)

      @car.build_sale_transfer(
        @car.acquisition_transfer
            .shared_attributes
            .merge(sale_transfer_params(stock))
      ).save(validate: false)
      @car.build_prepare_record

      build_stock_out_inventory(stock)
      @car.save(validate: false)

      stock.appropriate = @car
    end

    def import_reservations(stock)
      stock.car_reservations.each do |reservation|
        @car.car_reservations.create!(
          sales_type: reservation.sale_kind.to_i == 0 ? "retail" : "wholesale",
          reserved_at: reservation.create_time,
          customer_channel_id: reservation.channel.try(:appropriate_id),
          seller_id: reservation.seller.try(:appropriate_id),
          closing_cost_wan: to_wan(reservation.deal_price),
          deposit_wan: to_wan(reservation.front_money),
          note: reservation.other_desc,
          customer_location_province: reservation.region.try { |r| r.parent.region_name },
          customer_location_city: reservation.region.try(:region_name),
          customer_location_address: reservation.cust_addr,
          customer_name: reservation.cust_name,
          customer_phone: reservation.cust_tel,
          customer_idcard: reservation.cust_cert_no,
          current: reservation.valid_tag.to_i == 1,
          created_at: reservation.create_time,
          cancelable_price: to_wan(reservation.cancel_price),
          canceled_at: reservation.cancel_date
        )
        @car.update_columns(
          reserved_at: reservation.create_time,
          reserved: stock.vehicle_state.to_i == 9
        )
      end
    end

    def build_stock_out_inventory(stock)
      case stock.vehicle_state.to_i
      when 6 # sold
        return unless stock.sale_transfer.present?
        sale_transfer = stock.sale_transfer

        @car.build_sale_record(
          completed_at: Util::Date.parse_date_string(sale_transfer.deal_date),
          seller_id: sale_transfer.seller.try(:appropriate_id),
          customer_channel_id: sale_transfer.channel.try(:appropriate_id),
          closing_cost_cents: sale_transfer.sale_price,
          sales_type: sale_transfer.sales_type,
          payment_type: sale_transfer.payment_type,
          deposit_cents: sale_transfer.front_money,
          remaining_money_cents: sale_transfer.remaining_money_cents,
          transfer_fee_cents: sale_transfer.transfer_fee,
          commission_cents: sale_transfer.comm_fee,
          customer_location_province: sale_transfer.customer_location_province,
          customer_location_city: sale_transfer.region.try(:region_name),
          customer_location_address: sale_transfer.cust_addr,
          customer_name: sale_transfer.cust_name,
          customer_phone: sale_transfer.cust_tel_num,
          customer_idcard: sale_transfer.cust_cert_no,
          proxy_insurance: sale_transfer.insur_tag.to_i == 1,
          note: sale_transfer.sale_remark,
          insurance_company_id: sale_transfer.insurance_company.try(:appropriate_id),
          commercial_insurance_fee_cents: sale_transfer.syx_fee,
          compulsory_insurance_fee_cents: sale_transfer.jqx_fee,
          mortgage_company_id: sale_transfer.mortgage_company.try(:appropriate_id),
          down_payment_cents: sale_transfer.first_pay,
          loan_amount_cents: sale_transfer.loan_limit,
          mortgage_period_months: sale_transfer.mortgage_month,
          mortgage_fee_cents: sale_transfer.mortgage_fee,
          foregift_cents: sale_transfer.deposit_fee,
          created_at: sale_transfer.create_time,
          updated_at: sale_transfer.update_time
        ).save(validate: false)
      when 7 # acquisition_refunded
        return unless stock.acquisition_transfer.present?
        acquisition_transfer = stock.acquisition_transfer

        @car.build_acquisition_refund_record(
          refund_price_cents: acquisition_transfer.refund_price,
          refunded_at: acquisition_transfer.refund_time,
          created_at: acquisition_transfer.create_time,
          updated_at: acquisition_transfer.update_time
        ).save(validate: false)
      when 8 # driven_back
        @car.build_driven_back_record(
          driven_back_at: stock.drive_back_time,
          note: stock.drive_back_desc,
          returned_at: stock.back_return_time,
          created_at: stock.drive_back_time,
          updated_at: stock.back_return_time
        ).save(validate: false)
      end

      return unless @car.stock_out_inventories.present?
      inventory = @car.stock_out_inventories.max_by { |s| s.created_at.to_i }

      return unless inventory
      @car.stock_out_at = inventory.created_at
      @car.stock_out_inventories.each { |s| s.update_columns(current: false) }
      inventory.update_columns(current: true)
    end

    def car_params(stock)
      acquisition_transfer = stock.acquisition_transfer
      vehicle = stock.vehicle

      {
        acquirer_id: stock.buy_staff_user.try(:appropriate_id) || @owner.id,
        shop_id: stock.shop.try(:appropriate_id),
        acquired_at: acquisition_transfer.acquired_at.try(:beginning_of_day),
        stock_number: stock.stock_no,
        channel_id: stock.channel.try(:appropriate_id),
        acquisition_type: stock.acquisition_type,
        cooperation_company_relationships_attributes: stock
          .cooperation_company_attributes,
        manufacturer_configuration: nil, # 厂商不导入
        acquisition_price_wan: to_wan(acquisition_transfer.buy_price) || 0,
        vin: vehicle.shelf_code,
        state: stock.state,
        state_note: stock.mstate_desc,
        brand_name: vehicle.brand_name.present? ? vehicle.brand_name : "未填写",
        manufacturer_name: nil,
        series_name: vehicle.series_name.present? ? vehicle.series_name : "未填写",
        style_name: vehicle.style_name,
        car_type: nil, # 车辆类型对应不上了, 不导入
        door_count: vehicle.car_door_num,
        displacement: vehicle.output_volume,
        is_turbo_charger: vehicle.turbo_charger?,
        fuel_type: vehicle.fuel_type,
        transmission: vehicle.transmission,
        exterior_color: vehicle.car_color,
        interior_color: vehicle.upholstery_color,
        mileage: vehicle.mileage_count.try { |m| m / 10_000.0 },
        mileage_in_fact: vehicle.actual_mileage.try { |m| m / 10_000.0 },
        emission_standard: vehicle.emission_standard,
        license_info: vehicle.regist_month.present? ? "licensed" : "unlicensed",
        licensed_at: vehicle.licensed_at,
        manufactured_at: vehicle.manufactured_at,
        show_price_wan: to_wan(stock.show_price),
        online_price_wan: to_wan(stock.web_price),
        sales_minimun_price_wan: to_wan(stock.bottom_price),
        manager_price_wan: to_wan(stock.manager_price),
        alliance_minimun_price_wan: nil, # 联盟底价不导入, 暂无
        new_car_guide_price_wan: to_wan(stock.newcar_ref_price),
        new_car_additional_price_wan: to_wan(stock.newcar_add_price),
        new_car_discount: stock.newcar_discount,
        new_car_final_price_wan: to_wan(stock.newcar_deal_price),
        interior_note: vehicle.cond_desc,
        star_rating: 5, # 车辆星级不导入
        warranty_id: stock.warranty.try(:appropriate_id),
        warranty_fee_yuan: stock.warranty_fee.try { |p| p / 100.0 },
        is_fixed_price: stock.ykj_tag.present? ? stock.ykj_tag.to_i == 1 : nil,
        allowed_mortgage: stock.allowed_mortgage,
        mortgage_note: stock.mortgage_desc,
        selling_point: stock.market_desc,
        images_attributes: vehicle.vehicle_images_attributes,
        maintain_mileage: vehicle.maintain_mileage.try { |m| m / 1000.0 },
        has_maintain_history: vehicle.maintain_history?,
        new_car_warranty: vehicle.new_car_warranty,
        created_at: vehicle.create_time,
        updated_at: vehicle.update_time,
        configuration_note: vehicle.standard_equip,
        consignor_name: acquisition_transfer.try(:consign_person),
        consignor_phone: acquisition_transfer.try(:consign_tel),
        consignor_price_wan: to_wan(acquisition_transfer.try(:consign_price))
      }.tap do |hash|
        if hash[:acquisition_type] == "consignment"
          hash[:consignor_name] = "未填写" unless hash[:consignor_name].present?
          hash[:consignor_phone] = "未填写" unless hash[:consignor_phone].present?
          hash[:consignor_price_wan] = 0 unless hash[:consignor_price_wan].present?
        end
      end
    end

    def acquisition_transfer_params(stock)
      {
        key_count: stock.vehicle.car_key,
        compulsory_insurance_end_at: stock.vehicle.compulsory_insurance_end_at,
        annual_inspection_end_at: stock.vehicle.annual_inspection_end_at,
        commercial_insurance_end_at: stock.vehicle.commercial_insurance_end_at,
        commercial_insurance_amount_cents: stock.vehicle.comm_issur_fee,
        images_attributes: stock.vehicle.acquisition_transfer_images_attributes
      }.tap do |hash|
        if stock.acquisition_transfer_info.present?
          transfer = stock.acquisition_transfer_info

          hash.merge!(
            user_id: transfer.buy_staff_user.try(:appropriate_id) || @owner.id,
            items: transfer.items, # 需要对应
            original_owner: transfer.owner_name,
            original_owner_contact_mobile: transfer.contact_tel,
            transfer_fee_cents: transfer.transfer_fee,
            estimated_transferred_at: transfer.pre_finish_date,
            note: transfer.other_desc,
            created_at: transfer.create_time,
            updated_at: transfer.update_time
          )
        end
      end
    end

    def sale_transfer_params(stock)
      return {} unless stock.sale_transfer_info
      transfer = stock.sale_transfer_info

      {
        user_id: transfer.sell_staff_user.try(:appropriate_id),
        items: transfer.items,
        transfer_fee_cents: transfer.transfer_fee,
        estimated_transferred_at: transfer.pre_finish_date,
        note: transfer.other_desc,
        created_at: transfer.create_time,
        updated_at: transfer.update_time
      }
    end

    def company_owner=(owner)
      @owner = owner
      @company.update(owner_id: owner.id)

      User::AuthorityService.new(owner).init_default_roles!
    end

    def set_manager_ids
      @corp.staffs.where("parent_id is not null").includes(:parent).each do |staff|
        staff.appropriate.update_columns(manager_id: staff.parent.appropriate_id)
      end
    end

    def to_wan(fen)
      fen.to_i > 0 ? fen / 1_000_000.0 : 0 if fen
    end

    def create_price_tag_template
      return unless @company.owner.present?

      PriceTagTemplate::CreateService.new(
        @company.owner, "#{Rails.root}/lib/templates/price_tag/default.zip",
        "default", name: "默认模板"
      ).execute
    end

    def clear_redis
      RedisClient.current.keys("che3bao/*").each do |key|
        RedisClient.current.pipelined do
          RedisClient.current.del key
        end
      end
    end

    def self.merge_company(company_id, target_id)
      @company = Company.find(company_id)

      @company.users.update_all(company_id: target_id)
      @company.authority_roles.update_all(company_id: target_id)
      @company.channels.update_all(company_id: target_id)
      @company.warranties.update_all(company_id: target_id)
      @company.cooperation_companies.update_all(company_id: target_id)
      @company.mortgage_companies.update_all(company_id: target_id)
      @company.insurance_companies.update_all(company_id: target_id)

      @company.cars.update_all(company_id: target_id)
    end
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity
