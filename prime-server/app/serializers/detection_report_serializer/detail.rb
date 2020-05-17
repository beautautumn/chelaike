module DetectionReportSerializer
  class Detail < ActiveModel::Serializer
    attributes :id, :report_type, :url, :platform_name

    has_many :images, serializer: ImageSerializer::Common
  end
end
