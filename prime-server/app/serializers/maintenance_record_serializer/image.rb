module MaintenanceRecordSerializer
  class Image < ActiveModel::Serializer
    has_many :maintenance_images, serializer: ImageSerializer::Common
  end
end
