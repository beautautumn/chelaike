module V1
  module Chat
    class ConversationsController < ApplicationController
      before_action :skip_authorization

      def index
        @conversations = current_user.conversations

        render json: @conversations,
               each_serializer: ConversationSerializer::Common,
               root: "data"
      end

      def sync
        param! :conversation_type, String, in: Conversation::TYPES.map(&:to_s)
        param! :target_id, Integer
        param! :is_top, :boolean
        param! :is_blocked, :boolean

        find_conversation
        @conversation.is_top = params[:is_top] unless params[:is_top].nil?
        @conversation.is_blocked = params[:is_blocked] unless params[:is_blocked].nil?
        @conversation.save!

        render json: @conversation,
               serializer: ConversationSerializer::Common,
               root: "data"
      end

      private

      def find_conversation
        @conversation = Conversation.find_or_initialize_by(
          user_id: current_user.id,
          target_id: params[:target_id],
          conversation_type: params[:conversation_type]
        )
      end
    end
  end
end
