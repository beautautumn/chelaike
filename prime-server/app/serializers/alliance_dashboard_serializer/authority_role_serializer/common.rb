module AllianceDashboardSerializer
  module AuthorityRoleSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :name, :note, :created_at, :authorities
    end
  end
end
