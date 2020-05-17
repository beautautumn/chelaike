module DashenglaileRecordSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :brand_name, :series_name, :style_name,
               :vin, :state, :user_name, :token_price,
               :car_info, :result_description, :allow_share,
               :state_info

    attribute :format_last_fetch_at, key: :date

    def allow_share
      false
    end
  end
end
