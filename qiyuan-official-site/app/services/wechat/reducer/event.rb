# frozen_string_literal: true
require "upsert/active_record_upsert"

module Wechat
  class Reducer
    module Event
      # 用户订阅公众号事件
      # TODO: 目前似乎不起作用，原因待查
      def subscribe(app_id, event)
        wechat_app = WechatApp.find_by(app_id: app_id)
        if wechat_app && wechat_app.verify?
          user = Wechat::Mp::User.detail(app_id, event["FromUserName"])
          Rails.logger.info "SUB: #{user.inspect}"
          # WechatUser.upsert({ open_id: user[:open_id] }, user)
        end

        nil
      end

      # 用户退订公众号事件
      def unsubscribe(event)
        user = WechatUser.find_by(open_id: event["FromUserName"])
        return if user.blank?

        user.unsubscribe
        user.save

        nil
      end
    end
  end
end
