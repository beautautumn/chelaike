module AllianceDashboardSerializer
  module UserSerializer
    class AuthorityRoles < ActiveModel::Serializer
      attributes :id, :authority_type, :authorities, :created_at,
                 :first_letter

      has_many :authority_roles,
               serializer: AllianceDashboardSerializer::AuthorityRoleSerializer::Common
    end
  end
end
