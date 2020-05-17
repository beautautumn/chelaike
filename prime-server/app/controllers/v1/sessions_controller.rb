module V1
  class SessionsController < ApplicationController
    serialization_scope :anonymous

    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def create
      param! :user, Hash do |u|
        u.param! :login, String, required: true
        u.param! :password, String, required: true
      end

      session_service = User::SessionService.new(
        User.where(
          "lower(username) = lower(?) OR lower(phone) = lower(?)",
          user_params[:login], user_params[:login]
        ).first
      )
      @current_user = session_service.user

      begin
        if session_service.create(user_params[:password], request.headers)
          log_sign_in(@current_user)

          validate_locks

          render json: @current_user,
                 serializer: SessionSerializer::Common,
                 root: "data"
        else
          unauthorized_error("手机号码不存在或密码错误")
        end
      rescue User::Unauthorized => e
        unauthorized_error(e.message)
      end
    end

    private

    def user_params
      params.require(:user).permit(:login, :password)
    end

    def log_sign_in(user)
      LoginHistory.create(
        user_id: user.id,
        company_id: user.company_id,
        ip: request.remote_ip,
        user_agent: request.env["HTTP_USER_AGENT"],
        mac_address: request_header_or_param("AutobotsMacAddress"),
        device_number: request_header_or_param("AutobotsDeviceNumber")
      )
    end

    def validate_locks
      return unless @current_user.locked?

      current_mac_address_valid? if headers_key?("AutobotsMacAddress")
      current_device_number_valid? if headers_key?("AutobotsDeviceNumber")
    end

    def headers_key?(name)
      request.headers.key?(name)
    end
  end
end
