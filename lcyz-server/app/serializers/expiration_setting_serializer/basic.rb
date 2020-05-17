module ExpirationSettingSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :company_id, :notify_type,
               :first_notify, :second_notify, :third_notify,
               :created_at, :updated_at, :name
  end
end
