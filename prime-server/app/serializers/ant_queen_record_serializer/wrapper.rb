module AntQueenRecordSerializer
  class Wrapper < ActiveModel::Serializer
    has_one :ant_queen_record, serializer: AntQueenRecordSerializer::Detail
    has_many :maintenance_images, serializer: ImageSerializer::Common
  end
end
