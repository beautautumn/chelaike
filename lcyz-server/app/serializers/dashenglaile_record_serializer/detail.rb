module DashenglaileRecordSerializer
  class Detail < ActiveModel::Serializer
    attributes :car_id, :brand_name, :series_name,
               :state, :style_name, :vin, :stored,
               :result_description, :result_images,
               :notify_time, :total_mileage,
               :car_info, :emission_standard,
               :car_status, :new_car_warranty,
               :number_of_accidents, :last_time_to_shop,
               :id, :dashenglaile_record_hub_id, :query_text,
               :state_info, :allow_share

    def allow_share
      false
    end
  end
end
