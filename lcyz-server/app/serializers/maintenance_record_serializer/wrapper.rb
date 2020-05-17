module MaintenanceRecordSerializer
  class Wrapper < ActiveModel::Serializer
    has_one :ant_queen_record, serializer: AntQueenRecordSerializer::Detail
    has_one :maintenance_record, serializer: MaintenanceRecordSerializer::Detail
    has_one :cha_doctor_record, serializer: ChaDoctorRecordSerializer::Detail
    has_one :dashenglaile_record, serializer: DashenglaileRecordSerializer::Detail
    has_many :maintenance_images, serializer: ImageSerializer::Common
  end
end
