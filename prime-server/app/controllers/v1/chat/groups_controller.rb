module V1
  module Chat
    class GroupsController < ApplicationController
      before_action :skip_authorization

      def alliance
        @chat_group = ChatGroup.includes(chat_sessions: { user: :company })
                               .own_by_alliance.find(params[:id])

        render json: @chat_group,
               serializer: ChatGroupSerializer::Alliance,
               my_chat_info: current_user.group_chat_info(@chat_group),
               current_company_id: current_company.id,
               root: "data"
      end

      def company
        @chat_group = ChatGroup.includes(chat_sessions: { user: :company })
                               .own_by_company.find(params[:id])

        render json: @chat_group,
               serializer: ChatGroupSerializer::Company,
               my_chat_info: current_user.group_chat_info(@chat_group),
               root: "data"
      end

      def show
        @chat_group = ChatGroup.find(params[:id])

        render json: @chat_group,
               serializer: ChatGroupSerializer::Basic,
               current_user_existed: true,
               root: "data"
      end

      def name
        param! :name, String, required: true
        @chat_group = ChatGroup.find(params[:id])

        authorize @chat_group, :edit_name?

        ChatGroup::UpdateService.new(@chat_group).refresh_name(params[:name])

        render json: { message: :ok }, scope: nil
      end

      def nickname
        param! :nickname, String, required: true

        @chat_session = ChatSession.find_by!(
          user_id: current_user.id,
          target_id: params[:id],
          target_type: "ChatGroup"
        )
        @chat_session.update!(nick_name: params[:nickname])

        render json: { message: :ok }, scope: nil
      end

      def join_users
        return render json: { message: :ok }, scope: nil if params[:user_ids].blank?

        param! :user_ids, Array do |array, index|
          array.param! index, Integer, required: true
        end

        @chat_group = ChatGroup.find(params[:id])

        authorize @chat_group, :join_user?

        ChatGroup::UpdateService.new(@chat_group).join_user(params[:user_ids])

        render json: { message: :ok }, scope: nil
      end

      def quit_users
        param! :user_ids, Array do |array, index|
          array.param! index, Integer, required: true
        end

        @chat_group = ChatGroup.find(params[:id])

        authorize @chat_group, :quit_user?

        ChatGroup::UpdateService.new(@chat_group).quit_user(params[:user_ids])

        render json: { message: :ok }, scope: nil
      end

      def users
        param! :scope, String, in: %w(in_group not_in_group), default: "in_group"

        @chat_group = ChatGroup.find(params[:id])

        @users = case params[:scope]
                 when "not_in_group"
                   user_ids = @chat_group.user_ids
                   scope = current_company.enabled_users.where.not(id: user_ids)
                   # scope = scope.authorities_include("联盟管理") if @chat_group.own_by_alliance?
                   scope
                 when "in_group"
                   user_ids = current_company.user_ids
                   user_ids.delete(current_user.id)
                   @chat_group.users.where(id: user_ids)
                 end
        render json: @users,
               each_serializer: ChatSerializer::User::Basic,
               root: "data"
      end

      def all_users
        @chat_group = ChatGroup.includes(chat_sessions: { user: :company }).find(params[:id])

        render json: @chat_group,
               serializer: ChatGroupSerializer::AllUser,
               root: "data"
      end

      private

      def current_company
        @company ||= current_user.company
      end
    end
  end
end
