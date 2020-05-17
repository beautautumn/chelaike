module PasswordSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :username, :phone, :created_at
  end
end
