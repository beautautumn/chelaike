# frozen_string_literal: true

# 基本架构是从车来客 prime-server 中搬过来的，增加了开放平台相关的操作(open.rb)
# 并根据微信用户-公众号的多对多关系作了相应修改

module Wechat
  WECHAT_ID = ENV.fetch("OFFICIAL_SITE_ID")
  WECHAT_SECRET = ENV.fetch("OFFICIAL_SITE_SECRET")
  WECHAT_TOKEN = ENV.fetch("OFFICIAL_SITE_TOKEN")
  WECHAT_AES_KEY = ENV.fetch("OFFICIAL_SITE_AES_KEY")

  COMPONENT_VERIFY_TICKET_KEY = "wechat:component_verify_ticket"
  COMPONENT_ACCESS_TOKEN_KEY = "wechat:component_access_token"
  COMPONENT_PREAUTH_CODE_KEY = "wechat:component_preauth_code"

  APP_ACCESS_TOKEN_KEY = "wechat:app_access_token"
  USER_ACCESS_TOKEN_KEY = "wechat:user_access_token"

  def self.find_app_by(app_id)
    wechat_app = WechatApp.find_by(app_id: app_id)

    raise Wechat::Error::Unauthenticated if wechat_app.blank?

    wechat_app
  end
end
