module Wechat
  class Reducer
    module Msg
      include Wechat::Reply

      def transfer_customer_service_message(data)
        reply_transfer_customer_service_message(
          from: data["ToUserName"],
          to: data["FromUserName"]
        )
      end
    end
  end
end
