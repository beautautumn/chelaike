module V1
  class PasswordsController < ApplicationController
    serialization_scope :anonymous

    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def edit
      param! :user, Hash do |u|
        u.param! :phone, String, blank: false, required: true
      end
      user = User.find_by!(phone: params[:user][:phone])

      unless SMS.can?(user.pass_reset_expired_at)
        return forbidden_error("60秒内只能发送一次")
      end

      return validation_error(full_errors(user)) unless user.valid?

      pass_reset_token = SMS.generate_token
      user.set_reset_password_limit_key

      user.update!(
        pass_reset_token: pass_reset_token,
        pass_reset_expired_at: Time.zone.now + 10.minutes
      )

      Yunpian.send_to!(
        user.phone,
        I18n.t("yunpian.message", pass_reset_token: pass_reset_token)
      )

      render json: user, serializer: PasswordSerializer::ResetToken, root: "data"
    end

    def update
      param! :user, Hash do |u|
        u.param! :password, String, blank: false, required: true
      end

      user_params[:original_password] ? update_password : reset_password
    end

    private

    def update_password
      if current_user.authenticate(user_params[:original_password])
        current_user.update(password: user_params[:password])

        if current_user.errors.empty?
          render(
            json: current_user,
            serializer: PasswordSerializer::Common,
            root: "data"
          )
        else
          validation_error(full_errors(current_user))
        end
      else
        unauthorized_error("原密码不正确")
      end
    rescue
      unauthorized_error
    end

    def reset_password
      user = User.find_by(phone: params[:user][:phone])
      return not_found("账户不存在") if user.blank?

      unless user.pass_reset_token_valid?(
        user_params[:pass_reset_token],
        user_params[:phone]
      )
        return unauthorized_error
      end

      user.update(
        password: user_params[:password],
        pass_reset_token: nil
      )

      if user.errors.empty?
        render json: user, serializer: PasswordSerializer::Common, root: "data"
      else
        validation_error(full_errors(user))
      end
    end

    def user_params
      params.require(:user).permit(
        :phone, :password, :pass_reset_token, :original_password
      )
    end
  end
end
