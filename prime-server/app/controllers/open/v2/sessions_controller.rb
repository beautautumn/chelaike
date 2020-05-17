module Open
  module V2
    class SessionsController < Open::ApplicationController
      def verification_code
        user = current_company.users.find_by_phone(params[:phone])

        unless user
          render json: { msg: "用户不存在" }, scope: nil
          return
        end
        unless user.can?("微店管理权限")
          render json: { msg: "用户无微店管理权限" }, scope: nil
          return
        end
        unless SMS.can?(user.pass_reset_expired_at)
          render json: { msg: "60秒内只能发送一次" }, scope: nil
          return
        end

        code = SMS.generate_token
        user.set_reset_password_limit_key

        user.update!(
          pass_reset_token: code,
          pass_reset_expired_at: Time.zone.now + 10.minutes
        )

        Yunpian.send_to!(
          user.phone,
          I18n.t("yunpian.dash_board", code: code)
        )

        render json: { msg: "ok" }, scope: nil
      end

      def verify
        user = current_company.users.find_by_phone(params[:phone])

        unless user
          render json: { msg: "用户不存在" }, scope: nil
          return
        end
        unless user.can?("微店管理权限")
          render json: { msg: "用户无微店管理权限" }, scope: nil
          return
        end
        unless user.pass_reset_token_valid?(
            params[:code],
            params[:phone]
        )
          render json: { msg: "验证码无效" }, scope: nil
          return
        end

        render json: { msg: "ok" }, scope: nil
      end

    end
  end
end
