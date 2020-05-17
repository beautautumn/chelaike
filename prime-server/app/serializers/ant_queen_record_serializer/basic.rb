module AntQueenRecordSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :brand_name, :series_name, :style_name,
               :vin, :state, :user_name, :token_price,
               :state_info, :result_description

    attribute :format_last_fetch_at, key: :date

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
