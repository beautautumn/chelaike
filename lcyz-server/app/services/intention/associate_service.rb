class Intention < ActiveRecord::Base
  class AssociateService
    include ErrorCollector

    attr_reader :customer, :intention, :intention_push_history

    def initialize(customer_id: nil, customer_params: nil,
                   user: nil, car: nil,
                   intention_state: nil)
      @customer_id = customer_id
      @customer_params = customer_params
      @customer_phone = customer_params[:customer_phone]
      @user = user
      @car = car
      @intention_state = intention_state
    end

    def execute
      Intention.transaction do
        associate_customer

        associate_intention
      end
    rescue ActiveRecord::RecordInvalid
      self
    end

    protected

    def associate_customer
      @customer = find_or_init_customer

      @customer.assign_attributes(
        name: @customer_params[:customer_name],
        phone: @customer_params[:customer_phone],
        id_number: @customer_params[:customer_idcard],
        company_id: @user.company_id
      )
      @customer.note = region_note if @customer.new_record? && @customer.note.blank?

      @customer.save!
    end

    def region_note
      [
        @customer_params[:customer_location_province],
        @customer_params[:customer_location_city],
        @customer_params[:customer_location_address]
      ].join(" ")
    end

    def find_or_init_customer
      if @customer_id
        customer = customers_scope.find_by(id: @customer_id)
      elsif @customer_phone
        customer = customers_scope.phones_include(@customer_phone).first
      end

      customer = @user.customers.new unless customer
      fallible customer

      customer
    end

    def customers_scope
      return @customers_scope if @customers_scope

      @customers_scope = if @user.can?("代办客户预定/出库")
                           @user.company.customers
                         else
                           @user.customers
                         end
    end

    def associate_intention
      intention = find_or_init_intention(@customer)
      update_intention!(intention)
      return unless intention_valid?(intention)

      @intention = push_intention(intention)
    end

    def find_or_init_intention(customer)
      intention = Intention.create_with(intention_params(customer))
                           .find_or_initialize_by(
                             customer_id: customer.id,
                             intention_type: "seek"
                           )
      mortgage_period = @customer_params[:mortgage_period_months]

      intention.assign_attributes(
        mortgage_notify_date: Time.zone.today + mortgage_period.to_i.months,
        annual_inspection_notify_date: calculate_annual_inspection,
        insurance_notify_date: calculate_insurance_date,
        after_sale_assignee_id: intention.assignee_id # 设置服务归属人
      )
      intention
    end

    def update_intention!(intention)
      fallible intention

      if intention.persisted?
        intention.channel_id = @customer_params[:customer_channel_id]
        intention.state = @intention_state unless intention.in_state_finished?
      end
      intention.save!

      service = ExpirationNotificationService::Intention.new(intention, @user)
      service.execute
    end

    def calculate_annual_inspection
      licensed_at = @car.licensed_at
      return unless licensed_at

      current_date = Time.zone.today
      used_years = Time.zone.today - licensed_at
      month = licensed_at.month
      day = licensed_at.day

      year = if used_years < 7
               current_date.year + used_years % 2
             else
               current_date.year
             end

      Date.new(year, month, day)
    end

    # 交强险到期日期，要到 transfer_record 里去找
    def calculate_insurance_date
      insurance_end_date = @car.try(:acquisition_transfer).try(:compulsory_insurance_end_at)
      return unless insurance_end_date
      current_date = Time.zone.today
      if current_date < insurance_end_date
        insurance_end_date + 1.year
      else
        insurance_end_date
      end
    end

    def intention_params(customer)
      {
        customer_name: customer.name,
        creator_id: @user.id,
        creator_type: "User",
        assignee_id: @customer_params[:seller_id] || @user.id,
        company_id: @user.company_id,
        shop_id: @user.shop_id,
        customer_phones: customer.phones,
        customer_phone: customer.phone,
        gender: customer.gender,
        state: @intention_state,
        channel_id: @customer_params[:customer_channel_id]
      }
    end

    def intention_valid?(intention)
      intention && (
        (@intention_state == "completed" && intention.state.completed?) ||
        !intention.in_state_finished?
      )
    end

    def push_intention(intention)
      params = {
        state: @intention_state,
        processing_time: Time.zone.now,
        car_ids: [@car.id]
      }
      params[:closing_car_id] = @car.id if intention.state == "completed"

      service = IntentionPushHistory::CreateService.new(
        @user, intention, params
      ).execute(prevent_syncing_stock_out_inventory: true)

      @intention_push_history = service.intention_push_history
      fallible @intention_push_history
      service.intention
    end
  end
end
