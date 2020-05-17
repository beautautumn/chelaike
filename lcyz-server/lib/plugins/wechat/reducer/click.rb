module Wechat
  class Reducer
    module Click
      # 自定义菜单
      def handle_click(app_id, data)
        ws = ::WechatMessage.find_by(app_id: app_id, key: data["EventKey"])
        return unless ws
        ws.deliver_xml(from: data["ToUserName"], to: data["FromUserName"])
      end
    end
  end
end
