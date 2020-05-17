# frozen_string_literal: true
module Wechat
  class App
    extend Request
    extend Component

    class << self
      def profile(app_id)
        url = <<-URL.strip_heredoc
          https://api.weixin.qq.com/cgi-bin/component/api_get_authorizer_info?
          component_access_token=#{component_access_token}
        URL

        data = wechat_post(url, component_appid: WECHAT_ID, authorizer_appid: app_id)
        app_info = data["authorizer_info"]
        app_info ? application_info(app_info) : {}
      end

      def app_access_token(app_id)
        Rails.cache.fetch("#{APP_ACCESS_TOKEN_KEY}:#{app_id}", expires_in: 6000.seconds) do
          wechat_app = WechatApp.find_by(app_id: app_id)

          url = <<-URL.strip_heredoc
            https://api.weixin.qq.com/cgi-bin/component/api_authorizer_token?
            component_access_token=#{component_access_token}
          URL

          data = wechat_post(url, component_appid: WECHAT_ID,
                                  authorizer_appid: app_id,
                                  authorizer_refresh_token:  wechat_app.refresh_token)

          if data["authorizer_refresh_token"].present?
            save_refresh_token(wechat_app, data["authorizer_refresh_token"])
          end

          data["authorizer_access_token"]
        end
      end

      # 微信提供的短链接服务
      # https://mp.weixin.qq.com/wiki?action=doc&id=mp1443433600&t=0.7706627429266981
      def long2short(long_url, app_id)
        url = <<-URL.strip_heredoc
          https://api.weixin.qq.com/cgi-bin/shorturl?access_token=
          #{app_access_token(app_id)}
        URL
        data = wechat_post(url, action: "long2short", long_url: long_url)
        data["short_url"] if data["short_url"].present?
      end

      def set_app_access_token(app_id, access_token)
        Rails.cache.write(
          "#{APP_ACCESS_TOKEN_KEY}:#{app_id}", access_token, expires_in: 6000.seconds
        )
      end

      private

      def save_refresh_token(app, refresh_token)
        app.refresh_token = refresh_token
        app.save!
      end

      def application_info(data)
        {
          nick_name: data["nick_name"],
          head_img: data["head_img"],
          user_name: data["user_name"],
          alias: data["alias"],
          qrcode_url: data["qrcode_url"],
          business_info: data["business_info"],
          service_type_info: data["service_type_info"]["id"],
          verify_type_info: data["verify_type_info"]["id"]
        }
      end
    end
  end
end
