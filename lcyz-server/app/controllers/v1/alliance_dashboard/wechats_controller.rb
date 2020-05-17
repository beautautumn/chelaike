module V1
  module AllianceDashboard
    class WechatsController < V1::AllianceDashboard::ApplicationController
      skip_before_action :authenticate_user!, except: %i(authorization)
      before_action :skip_authorization

      def authorized_callback
        Wechat::AuthorizationService.new(
          params[:auth_code], AllianceCompany::Company.find(params[:company_id])
        ).execute
        render text: "授权成功。"
      end

      def authorization
        # authorize WechatApp, :manage?
        @wechat_app = WechatApp.find_by(company_id: current_user.alliance_company)
        render json: { data: authorization_info }, scope: nil
      end

      private

      def authorization_info
        if @wechat_app && @wechat_app.state.enabled?
          {
            wechat_app: {
              user_name: @wechat_app.user_name,
              nick_name: @wechat_app.nick_name,
              service_type_info: @wechat_app.service_type_info,
              verify_type_info: @wechat_app.verify?
            },
            authorization_url: nil
          }
        else
          {
            wechat_app: nil,
            authorization_url: generate_authorization_url
          }
        end
      end

      def generate_authorization_url
        wechat_id = Wechat::WECHAT_ID
        preauth_code = Wechat::App.preauth_code
        company_id = current_user.company_id
        callback_url = <<-URL.strip_heredoc.delete("\n")
          #{ENV["SERVER_HOST"]}/api/v1/alliance_dashboard/wechats/authorized_callback?
          company_id=#{company_id}
        URL

        wechat_authorization_url = <<-URL.strip_heredoc.delete("\n")
          https://mp.weixin.qq.com/cgi-bin/componentloginpage?
          component_appid=#{wechat_id}
          &pre_auth_code=#{preauth_code}
          &redirect_uri=#{CGI.escape(callback_url)}
        URL

        @prime_authorization_url = <<-URL.strip_heredoc.delete("\n")
          #{ENV["SERVER_HOST"]}/api/v1/wechats/pre_auth?
          url=#{CGI.escape(wechat_authorization_url)}
        URL
      end
    end
  end
end
