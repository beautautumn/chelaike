module ChannelSerializer
  class WechatQrcode < ActiveModel::Serializer
    attributes :id, :name, :company_id, :company_type, :note, :created_at, :wechat_qrcode_url
  end
end
