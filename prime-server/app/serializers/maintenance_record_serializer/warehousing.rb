module MaintenanceRecordSerializer
  class Warehousing < ActiveModel::Serializer
    attributes :vin, :brand_name, :style_name, :transmission, :displacement
  end
end
