module MaintenanceRecordSerializer
  class Summary < ActiveModel::Serializer
    attributes :id, :car_name, :brand_name, :series_name, :style_name,
               :vin, :state, :user_name, :token_price,
               :state_info, :items, :abstract_items

    attribute :format_last_fetch_at, key: :date
  end
end
