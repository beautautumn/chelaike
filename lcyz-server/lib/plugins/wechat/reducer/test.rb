module Wechat
  class Reducer
    module Test
      # 开放平台测试用例
      def test_case(message)
        test_app_id = "wx570bc396a51b8ff8"

        if message["Event"]
          return Wechat::Mp::Message
                 .text(test_app_id, message["FromUserName"], "#{message["Event"]}from_callback")
        end

        case message["Content"]
        when "TESTCOMPONENT_MSG_TYPE_TEXT"

          Wechat::Mp::Message
            .text(test_app_id, message["FromUserName"], "TESTCOMPONENT_MSG_TYPE_TEXT_callback")
        when /^QUERY_AUTH_CODE/
          test_app = WechatApp.find_by(app_id: test_app_id)

          auth_code = message["Content"].match(/^QUERY_AUTH_CODE:(.*)/).captures.first

          response = Wechat::App.authorize_app(auth_code)
          token = response["authorization_info"]["authorizer_refresh_token"]

          test_app.refresh_token = token
          test_app.save

          Wechat::Mp::Message
            .text(test_app_id, message["FromUserName"], "#{auth_code}_from_api")
        end
      end
    end
  end
end
