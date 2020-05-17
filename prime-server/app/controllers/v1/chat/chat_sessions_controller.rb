module V1
  module Chat
    class ChatSessionsController < ApplicationController
      before_action :skip_authorization

      def info
        user_id = params[:user_id]
        group_id = params[:group_id]

        chat_session = ChatSession.includes(:target)
                                  .where(user_id: user_id, target_id: group_id)
                                  .first
        result = {
          user_id: user_id, group_id: group_id,
          nickname: chat_session.try(:nickname),
          group_name: chat_session.try(:target).try(:name),
          logo: chat_session.try(:target).try(:logo)
        }

        render json: { data: result },
               scope: nil
      end

      def batch_infos
        arr = params[:data]
        result = arr.each_with_object([]) do |d, acc|
          user_id = d[:user_id]
          group_id = d[:group_id]

          chat_session = ChatSession.includes(:target)
                                    .where(user_id: user_id, target_id: group_id)
                                    .first

          acc << {
            user_id: user_id, group_id: group_id,
            nickname: chat_session.nickname,
            group_name: chat_session.target.name
          }
        end

        render json: { data: result },
               scope: nil
      end
    end
  end
end
