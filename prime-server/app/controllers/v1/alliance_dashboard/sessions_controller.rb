# 联盟公司用户session管理
module V1
  module AllianceDashboard
    class SessionsController < V1::AllianceDashboard::ApplicationController
      skip_before_action :authenticate_user!
      before_action :skip_authorization

      serialization_scope :anonymous

      def create
        param! :user, Hash do |u|
          u.param! :login, String, required: true
          u.param! :password, String, required: true
        end

        begin
          @current_user = AllianceCompanyService::User::Login.new(
            user_params[:login], user_params[:password]
          ).login

          render json: @current_user,
                 serializer: AllianceDashboardSerializer::SessionSerializer::Common,
                 root: "data"

        rescue AllianceCompanyService::User::LoginError
          unauthorized_error("手机号码不存在或密码错误")
        end
      end

      private

      def user_params
        params.require(:user).permit(:login, :password)
      end
    end
  end
end
