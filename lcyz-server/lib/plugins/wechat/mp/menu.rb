module Wechat
  module Mp
    class Menu
      extend Request

      # Adapter {"msg"=> "click", "url"=> "view"}
      ButtonType = %w(
        msg url scancode_push scancode_waitmsg pic_sysphoto pic_photo_or_album
        pic_weixin location_select media_id view_limited group
      ).map(&:freeze).freeze

      def self.update(app_id, menus)
        url = <<-URL.strip_heredoc
          https://api.weixin.qq.com/cgi-bin/menu/create?
          access_token=#{App.app_access_token(app_id)}
        URL

        response = wechat_post(url, menus)
        raise Wechat::Error::Menu, response["errmsg"] if response["errcode"] != 0
      end
    end
  end
end
