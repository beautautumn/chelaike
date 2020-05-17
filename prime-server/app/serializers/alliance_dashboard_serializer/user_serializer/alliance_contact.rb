module AllianceDashboardSerializer
  module UserSerializer
    class AllianceContact < ActiveModel::Serializer
      attributes :id, :phone, :name, :first_letter
    end
  end
end
