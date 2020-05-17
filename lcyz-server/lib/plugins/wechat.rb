module Wechat
  WECHAT_AES_KEY = ENV.fetch("WECHAT_OPEN_APP_ENCODING_AES_KEY")
  WECHAT_TOKEN = ENV.fetch("WECHAT_OPEN_APP_TOKEN")
  WECHAT_ID = ENV.fetch("WECHAT_OPEN_APP_ID")
  WECHAT_SECRET = ENV.fetch("WECHAT_OPEN_APP_SECRET")

  COMPONENT_VERIFY_TICKET_KEY = "wechat:component_verify_ticket".freeze
  COMPONENT_ACCESS_TOKEN_KEY = "wechat:component_access_token".freeze
  COMPONENT_PREAUTH_CODE_KEY = "wechat:component_preauth_code".freeze

  APP_ACCESS_TOKEN_KEY = "wechat:app_access_token:".freeze

  def self.find_app_by(app_id)
    wechat_app = WechatApp.find_by(app_id: app_id)

    raise Wechat::Error::Unauthenticated if wechat_app.blank?

    wechat_app
  end
end
