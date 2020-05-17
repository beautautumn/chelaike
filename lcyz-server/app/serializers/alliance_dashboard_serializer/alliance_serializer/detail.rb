module AllianceDashboardSerializer
  module AllianceSerializer
    class Detail < ActiveModel::Serializer
      attributes :id, :name, :note, :created_at, :authorities
    end
  end
end
