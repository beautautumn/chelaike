module PasswordSerializer
  class ResetToken < ActiveModel::Serializer
    attributes :phone, :created_at
  end
end
