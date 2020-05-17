module AllianceDashboardSerializer
  module UserSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :username, :phone, :authority_type, :authorities, :created_at,
                 :avatar, :name, :state, :note, :email,
                 :settings, :first_letter
      has_many :authority_roles, serializer: AuthorityRoleSerializer::Create
      has_one :manager, serializer: Basic
      belongs_to :alliance_company, serializer: AllianceCompanySerializer::Common
    end
  end
end
