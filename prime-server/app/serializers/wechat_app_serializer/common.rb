module WechatAppSerializer
  class Common < ActiveModel::Serializer
    attributes :app_id, :user_name, :nick_name, :service_type_info
  end
end
