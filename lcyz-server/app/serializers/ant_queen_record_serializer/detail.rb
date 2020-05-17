module AntQueenRecordSerializer
  class Detail < ActiveModel::Serializer
    attributes :car_id, :brand_name, :series_name,
               :state, :style_name, :vin, :stored,
               :result_description, :result_images,
               :notify_time, :total_mileage,
               :car_info, :car_status, :text_img_json,
               :query_text, :text_contents_json,
               :number_of_accidents, :last_time_to_shop,
               :id, :ant_queen_record_hub_id

    def result_description
      r = object.try(:ant_queen_record_hub).try(:result_description)
      return nil if r.blank? || r.start_with?("[")
      r
    end

    def vin
      v = object.try(:vin)
      return nil if v.blank? || v.start_with?("HTTP")
      v
    end
  end
end
