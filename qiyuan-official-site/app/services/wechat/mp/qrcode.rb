# frozen_string_literal: true
module Wechat
  module Mp
    class Qrcode
      extend Request

      # 永久二维码
      def self.generate(app_id, scene)
        url = <<-URL.strip_heredoc
          https://api.weixin.qq.com/cgi-bin/qrcode/create?
          access_token=#{App.app_access_token(app_id)}
        URL

        data = {
          action_name: "QR_LIMIT_STR_SCENE",
          action_info: {
            scene: {
              scene_str: scene
            }
          }
        }

        ticket = wechat_post(url, data)["ticket"]

        raise Wechat::Error::Unauthenticated if ticket.blank?

        "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{CGI.escape(ticket)}"
      end
    end
  end
end
