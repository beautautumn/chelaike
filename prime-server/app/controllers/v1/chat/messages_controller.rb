# 用户聊天信息控制
module V1
  module Chat
    class MessagesController < ApplicationController
      before_action :skip_authorization

      def private_publish
        message = Rongcloud::Message.new(
          params
        )

        result = message.private_send
        if result
          render json: { data: "ok" }
        else
          render json: { data: "error" }
        end
      end
    end
  end
end
