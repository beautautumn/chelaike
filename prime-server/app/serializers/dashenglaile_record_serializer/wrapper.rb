module DashenglaileRecordSerializer
  class Wrapper < ActiveModel::Serializer
    has_one :dashenglaile_record, serializer: DashenglaileRecordSerializer::Detail
    has_many :maintenance_images, serializer: ImageSerializer::Common
  end
end
