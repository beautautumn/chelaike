module Wechat
  module Component
    include Crypto
    extend Request

    def signature?(timestamp, nonce, signature)
      generate_signature(timestamp, nonce, WECHAT_TOKEN) == signature
    end

    def set_component_verify_ticket(messages, encrypted_message)
      return unless signature?(messages[:timestamp], messages[:nonce], messages[:signature])

      decrypt_message = decrypt(encrypted_message)

      case decrypt_message["InfoType"]
      when "unauthorized"
        app = WechatApp.find_by(app_id: decrypt_message["AuthorizerAppid"])
        app.update(state: "disabled")
      else
        ticket = decrypt(encrypted_message)["ComponentVerifyTicket"]
        return unless ticket

        Rails.cache.write(COMPONENT_VERIFY_TICKET_KEY, ticket, expires_in: 6000.seconds)
      end
    end

    def component_verify_ticket
      Rails.cache.read(COMPONENT_VERIFY_TICKET_KEY)
    end

    def component_access_token
      Rails.cache.fetch(COMPONENT_ACCESS_TOKEN_KEY, expires_in: 6000.seconds) do
        response = wechat_post(
          "https://api.weixin.qq.com/cgi-bin/component/api_component_token",
          component_appid: WECHAT_ID,
          component_appsecret: WECHAT_SECRET,
          component_verify_ticket: component_verify_ticket
        )

        response["component_access_token"]
      end
    end

    def authorize_app(auth_code)
      url = <<-URL.strip_heredoc
        https://api.weixin.qq.com/cgi-bin/component/api_query_auth?
        component_access_token=#{component_access_token}
      URL

      wechat_post(url, component_appid: WECHAT_ID, authorization_code: auth_code)
    end

    def preauth_code
      Rails.cache.fetch(COMPONENT_PREAUTH_CODE_KEY, expires_in: 1600.seconds) do
        url = <<-URL.strip_heredoc
          https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?
          component_access_token=#{component_access_token}
        URL

        response = wechat_post(url, component_appid: WECHAT_ID)
        response["pre_auth_code"]
      end
    end
  end
end
