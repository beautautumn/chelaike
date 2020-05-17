module CarSerializer
  class ShownAlliance < ActiveModel::Serializer
    attributes :id
    has_many :all_alliances, serializer: AllianceSerializer::Mini
    has_many :allowed_alliances, serializer: AllianceSerializer::Mini
  end
end
