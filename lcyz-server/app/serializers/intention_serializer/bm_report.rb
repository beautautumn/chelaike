module IntentionSerializer
  class BmReport < ActiveModel::Serializer
    attributes :id, :customer_id, :shop_city, :shop_name,
               :assignee_name, :customer_name,
               :customer_phone, :customer_phones,
               :intention_push_days,
               :state_text, :seek_description, :price_range_text,
               :state_text, :channel_name,
               :intention_level_name,
               :city, :created_at,
               :intention_completed, :checked_out,
               :expired, :latest_push_history_note,
               :latest_push_history_created_at,
               :push_histories_text,
               :matched_cars

    def customer
      @_customer ||= object.customer
    end

    def shop
      @_shop ||= object.shop
    end

    def latest_push_history
      @_latest_push_history ||= object.latest_intention_push_history
    end

    def assignee
      @_assignee ||= object.assignee
    end

    def channel_name
      object.channel.try(:name)
    end

    def intention_level_name
      object.intention_level.try(:name)
    end

    def shop_city
      shop.try(:city)
    end

    def shop_name
      shop.try(:name)
    end

    def assignee_name
      assignee.try(:name)
    end

    def intention_push_days
      latest_push_history = object.latest_intention_push_history
      return 0 unless latest_push_history
      (Time.zone.today - latest_push_history.created_at.to_date).to_i
    end

    def intention_completed
      object.sold_completed? ? "已成交" : "未成交"
    end

    def checked_out
      object.checked_count > 0 ? "到店过" : "未到店"
    end

    def latest_push_history_note
      latest_push_history.try(:note)
    end

    def latest_push_history_created_at
      latest_push_history.try(:created_at)
    end

    def push_histories_text
      object.push_histories_text
    end

    def expired
      object.expired?
    end

    def matched_cars
      condition = object.seeking_cars_condition
      cars = object.company.cars
                   .state_in_stock_scope
                   .where(reserved: false)
                   .where(condition)
      cars.map { |matched_car| "#{matched_car.brand_name} #{matched_car.series_name}" }
          .join("、")
    end
  end
end
