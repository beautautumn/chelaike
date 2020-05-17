module ObjectDiff
  class Car < Base
    COLUMNS = %i(
      shop_id acquirer_id channel_id warranty_id acquired_at stock_number vin
      state_note brand_name manufacturer_name series_name style_name door_count
      displacement exterior_color interior_color mileage mileage_in_fact
      manufactured_at new_car_discount interior_note star_rating mortgage_note
      selling_point maintain_mileage yellow_stock_warning_days reserved_at
      consignor_name consignor_phone red_stock_warning_days acquisition_price_cents
      show_price_cents online_price_cents sales_minimun_price_cents manager_price_cents
      alliance_minimun_price_cents new_car_guide_price_cents new_car_additional_price_cents
      new_car_final_price_cents consignor_price_cents warranty_fee_cents acquisition_type
      car_type fuel_type transmission emission_standard new_car_warranty state level
      is_fixed_price allowed_mortgage has_maintain_history sellable is_turbo_charger
      license_info licensed_at manufacturer_configuration
    ).freeze

    def initialize(car)
      @car = car
      @target_klass = ::Car
    end

    def execute(changed_attributes)
      {}.tap do |hash|
        changed_attributes.dup.extract!(*COLUMNS).each do |key, old_value|
          diff = send(key, old_value)
          next unless diff.present?

          hash[key] = diff
        end
      end
    end

    # Example
    # def interior_note(old_value)
    #   [old_value, @car.send(:interior_note)]
    # end
    [:interior_note, :mortgage_note, :selling_point].each do |key|
      define_method key do |_old_value|
        ObjectDiff::Base::CHANGED_NOTE
      end
    end

    # Example
    # def shop_id(shop_id)
    #   ids = [shop_id, @car.shop_id]
    #   shops = Hash[Shop.where(id: ids).pluck(:id, :name)]
    #   ids.map { |id| shops[id].try(:name) }
    # end

    {
      shop_id: Shop,
      acquirer_id: User,
      channel_id: Channel,
      warranty_id: Warranty
    }.each do |key, klass|
      define_method key do |id|
        diff_ids([id, @car.send(key)], klass)
      end
    end

    # Example
    # def stock_number(value)
    #   [stock_number, @car.stock_number]
    # end

    [
      :acquired_at, :stock_number, :vin, :state_note, :brand_name, :manufacturer_name,
      :series_name, :style_name, :door_count, :displacement, :exterior_color, :interior_color,
      :mileage, :mileage_in_fact, :manufactured_at, :new_car_discount, :star_rating,
      :maintain_mileage, :yellow_stock_warning_days, :reserved_at, :consignor_name,
      :consignor_phone, :red_stock_warning_days, :level
    ].each do |key|
      define_method key do |old_value|
        [old_value, @car.send(key)]
      end
    end

    def acquired_at(acquired_at)
      [acquired_at.try(:to_date), @car.acquired_at.try(:to_date)]
    end

    # Example
    # def show_price_cents(old_price)
    #   old_price_wan = old_price.present? ? (old_price / 1_000_000.0).round(4) : nil
    #   [old_price_wan, @car.show_price_wan]
    # end

    [
      :acquisition_price, :show_price, :online_price, :sales_minimun_price,
      :manager_price, :alliance_minimun_price, :new_car_guide_price,
      :new_car_additional_price, :new_car_final_price, :consignor_price
    ].each do |key|
      define_method "#{key}_cents" do |old_price|
        old_price_wan = old_price.present? ? (old_price / 1_000_000.0).round(4) : nil
        new_price_wan = @car.send("#{key}_wan")

        [
          old_price_wan.blank? ? "空" : "#{old_price_wan} 万元",
          new_price_wan.blank? ? "空" : "#{new_price_wan} 万元"
        ].join(" 调整为 ")
      end
    end

    def warranty_fee_cents(old_price)
      old_price_yuan = old_price.present? ? (old_price / 100.0).round(4) : nil
      new_price_yuan = @car.warranty_fee_yuan

      [
        old_price_yuan.blank? ? "空" : "#{old_price_yuan} 元",
        new_price_yuan.blank? ? "空" : "#{new_price_yuan} 元"
      ].join(" 调整为 ")
    end

    # Example
    # def emission_standard(old_value)
    #   [locale(:emission_standard, old_value), @car.emission_standard_text]
    # end

    [
      :acquisition_type, :car_type, :fuel_type, :transmission,
      :emission_standard, :new_car_warranty, :state
    ].each do |key|
      define_method key do |old_value|
        [locale(key, old_value), @car.send("#{key}_text")]
      end
    end

    # Example
    # def allowed_mortgage(_boolean)
    #   @car.allowed_mortgage ? "可按揭" : "取消按揭"
    # end

    {
      allowed_mortgage: %w(可按揭 取消按揭),
      is_fixed_price: %w(一口价 取消一口价),
      has_maintain_history: %w(增加保养记录 删除保养记录),
      is_turbo_charger: %w(改为涡轮增压 改为自然吸气),
      sellable: %w(可售 不可售)
    }.each do |key, array|
      define_method key do |_|
        @car.send(key) ? array[0] : array[1]
      end
    end

    def license_info(old_value)
      arr = []
      old_value_text = locale(:license_info, old_value)
      new_value_text = locale(:license_info, @car.license_info)

      arr << if old_value == "licensed" && @car.licensed_at_was.present? # 脏数据可能没有上牌时间
               "#{old_value_text}(#{@car.licensed_at_was})"
             else
               old_value_text
             end

      arr << if @car.license_info == "licensed"
               "#{new_value_text}(#{@car.licensed_at})"
             else
               new_value_text
             end

      arr
    end

    def licensed_at(old_value)
      return if @car.license_info_changed?

      [old_value, @car.licensed_at]
    end

    def attachments(old_array)
      "去掉 所有车辆附件" unless @car.attachments.present?

      if old_array.present?
        attachments_added = (@car.attachments - old_array).map { |item| locale(:attachments, item) }
        attachments_removed = (old_array - @car.attachments).map do |item|
          locale(:attachments, item)
        end

        arr = []
        arr << "增加 #{attachments_added.join("、")}" if attachments_added.present?
        arr << "删除 #{attachments_removed.join("、")}" if attachments_removed.present?

        arr.join(", ")
      else
        attachments_added = @car.attachments.map { |item| locale(:attachments, item) }

        "增加 #{attachments_added.join("、")}"
      end
    end

    def manufacturer_configuration(old_array)
      return "删除 厂商配置" unless @car.manufacturer_configuration.present?
      return "增加 厂商配置" unless old_array.present?

      hash = {}.tap do |diffs|
        @car.manufacturer_configuration.each_with_index do |type, index|
          old_field = old_array[index]
          next if old_field.blank? || type == old_field

          details = type["fields"].each_with_object([]) do |item, arr|
            old_value = old_field["value"].to_s
            new_value = item["value"].to_s
            next if new_value == old_value

            arr << "#{item["name"]}(#{empty_value(old_value)} 调整为 #{empty_value(new_value)})"
          end

          diffs[type["name"]] = details.join(" ")
        end
      end

      hash.map { |name, diff| "#{name}[#{diff}]" }.join("、")
    end

    def locale(key, value)
      I18n.t("enumerize.car.#{key}.#{value}")
    end

    def keys_filter(user)
      keys = COLUMNS.map(&:to_s)

      keys = filter_prices(keys, user)

      unless User::Pundit.filter(user, @car, ["车主寄卖信息查看"]) || @car.acquirer_id == user.id
        keys -= [:consignor_name, :consignor_phone, :consignor_price_cents]
      end

      keys
    end

    def filter_prices(keys, user)
      unless @car.acquirer_id == user.id || User::Pundit.filter(user, @car, ["收购价格查看"])
        keys -= [:acquisition_price_cents]
      end

      keys -= [:alliance_minimun_price_cents] unless User::Pundit.filter(user, @car, ["联盟底价查看"])
      keys -= [:sales_minimun_price_cents] unless User::Pundit.filter(user, @car, ["销售底价查看"])
      keys -= [:manager_price_cents] unless User::Pundit.filter(user, @car, ["经理底价查看"])

      keys
    end
  end
end
