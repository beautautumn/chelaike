module MaintenanceRecordSerializer
  class Detail < ActiveModel::Serializer
    attributes :car_id, :car_name, :brand_name, :series_name,
               :style_name, :vin, :emission_standard, :emission_standard_text,
               :stored, :items, :report_at, :state,
               :displacement, :transmission,
               :id, :maintenance_record_hub_id, :abstract_items
  end
end
