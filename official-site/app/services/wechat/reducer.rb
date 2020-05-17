# frozen_string_literal: true
module Wechat
  class Reducer
    extend Crypto
    extend Reducer::Event
    extend Reducer::Scene
    extend Reducer::Test
    extend Reducer::Click
    extend Reducer::Msg

    EVENT_SUBSCRIBE = "subscribe"
    EVENT_UNSUBSCRIBE = "unsubscribe"
    EVENT_SCAN = "SCAN"
    EVENT_CLICK = "CLICK"

    PRICE_TAG_SCAN = "1"
    CHANNEL_SCAN = "2"

    class << self
      def execute(app_id, messages, encrypted_message)
        timestamp = messages[:timestamp]
        nonce = messages[:nonce]
        msg_signature = messages[:msg_signature]

        return if generate_signature(timestamp, nonce, WECHAT_TOKEN, encrypted_message)\
        != msg_signature

        message = decrypt(encrypted_message)
        event = message["Event"]

        # return test_case(message)

        if event
          handle_event(app_id, event, message)
        else
          handle_customer_message(message)
        end
      rescue => e
        ExceptionNotifier.notify_exception(e, data: { message: "微信异常" })
        nil
      end

      private

      def handle_event(app_id, event, message)
        case event
        when EVENT_SUBSCRIBE
          subscribe(app_id, message)
          scene = message["EventKey"].try(:gsub, "qrscene_", "")
          handle_scene(app_id, scene, message, true)
        when EVENT_UNSUBSCRIBE
          unsubscribe(message)
        when EVENT_SCAN
          handle_scene(app_id, message["EventKey"], message)
        when EVENT_CLICK
          handle_click(app_id, message)
        end
      end

      def handle_scene(app_id, scene, message, subscribe = false)
        return nil if scene.blank?
        data = JSON.parse(scene)

        action = subscribe ? "subscribe" : "scan"

        case data["type"].to_s
        when PRICE_TAG_SCAN
          record_action(app_id, message["FromUserName"], data, action)
          price_tag_scan(message, app_id, data)
        when CHANNEL_SCAN
          record_action(app_id, message["FromUserName"], data, action)
        end
      rescue JSON::ParserError
        nil
      end

      def record_action(app_id, open_id, data, action)
        WechatRecord.create(
          app_id: app_id,
          open_id: open_id,
          data: data,
          action: action
        )

        nil
      end

      def handle_customer_message(message)
        transfer_customer_service_message(message)
      end
    end
  end
end
