module AllianceDashboardSerializer
  module UserSerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :username, :phone, :authority_type, :authorities, :created_at,
                 :name, :email, :first_letter
    end
  end
end
