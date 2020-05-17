module V1
  module Chat
    class UsersController < ApplicationController
      before_action :skip_authorization

      def rc_token
        service = ChatService::User.new(current_user)
        service.rc_token

        render json: current_user,
               serializer: ChatSerializer::User::Basic,
               root: "data"
      end

      # 显示当前用户参与的私聊对象的具体信息
      def show
        group_id = params[:group_id]
        conversation = if group_id
                         Conversation.find_or_initialize_by(
                           user_id: params[:id],
                           target_id: group_id,
                           conversation_type: "group"
                         )
                       else
                         current_user.conversations.find_or_initialize_by(
                           target_id: params[:id],
                           conversation_type: "private"
                         )
                       end

        render json: User.find(params[:id]),
               serializer: ChatSerializer::User::Detail,
               conversation: conversation,
               root: "data"
      end

      # 得到可以进行私聊的用户列表
      def index
        param! :type, String, in: %w(company alliance),
                              default: "company"

        send("render_#{params[:type]}")
      end

      def query_users
        query = params[:query]
        type = params[:type] || "all"

        users = case type
                when "all"
                  service = ChatService::User.new(current_user)
                  service.all_users.ransack(query).result
                when "company"
                  current_company.enabled_users
                                 .ransack(query).result
                when "alliance"
                  service = ChatService::User.new(current_user)
                  service.same_alliance_users.ransack(query).result
                end

        render json: users,
               each_serializer: ChatSerializer::User::Basic,
               root: "data"
      end

      # 返回可进行直聊的联盟
      def alliances
        render json: current_company.alliances,
               each_serializer: AllianceSerializer::Basic,
               root: "data"
      end

      def groups
        groups = ChatGroup.where(id: current_user.chat_sessions.pluck(:target_id))
                          .in_use
        render json: groups,
               each_serializer: ChatGroupSerializer::Basic,
               users_count: true,
               root: "data"
      end

      def all_users
        user_ids = params[:user_ids]
        users = User.where(id: user_ids)

        render json: users,
               each_serializer: ChatSerializer::User::Basic,
               root: "data"
      end

      def system_messagers
        render json: User.where(id: [-100, -200, -300, -400]),
               each_serializer: ChatSerializer::User::Basic,
               root: "data"
      end

      private

      def render_company
        companies = [current_company]

        render json: companies,
               each_serializer: ChatSerializer::Company::WithUsers,
               root: "data"
      end

      def render_alliance
        alliance = Alliance.find(params[:alliance_id])
        companies = alliance.companies.where.not(id: current_company.id)

        render json: companies,
               each_serializer: ChatSerializer::Company::InAlliance,
               alliance_id: params[:alliance_id],
               root: "data"
      end

      def current_company
        @company ||= current_user.company
      end
    end
  end
end
