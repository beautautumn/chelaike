module AllianceDashboardSerializer
  module AuthorityRoleSerializer
    class Create < ActiveModel::Serializer
      attributes :id, :name, :note, :created_at, :authorities

      belongs_to :alliance_company, serializer: AllianceCompanySerializer::Common
    end
  end
end
