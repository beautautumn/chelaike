module V1
  class WechatsController < ApplicationController
    skip_before_action :authenticate_user!, except: %i(authorization)
    before_action :skip_authorization

    def authorize_callback
      Wechat::App.set_component_verify_ticket(params, encrypted_message)

      render text: "success"
    end

    def events_callback
      @wechat_app = WechatApp.find_by(app_id: params[:id])
      reply = Wechat::Reducer.execute(params[:id], params, encrypted_message)
      if reply
        render xml: reply
      else
        render text: "success"
      end
    end

    def authorized_callback
      Wechat::AuthorizationService.new(
        params[:auth_code], Company.find(params[:company_id])
      ).execute
      render text: "授权成功。车来客已接管应用，感谢您对车来客的支持。"
    end

    def authorization
      authorize WechatApp, :manage?
      @wechat_app = WechatApp.find_by(company_id: current_user.company_id)
      render json: { data: authorization_info }, scope: nil
    end

    def pre_auth
      authorization_html = <<-HTML.strip_heredoc
        <html>
          <script type="text/javascript">
            window.location.href="#{params[:url]}"
          </script>
          <body>跳转至微信授权页面中。。。</body>
        </html>
      HTML
      render html: authorization_html.html_safe
    end

    private

    def app_params
      @app_params ||= {
        app_id: @app_authorize_info.fetch("authorizer_appid"),
        access_token: @app_authorize_info.fetch("authorizer_access_token"),
        refresh_token: @app_authorize_info.fetch("authorizer_refresh_token"),
        expire: @app_authorize_info.fetch("expires_in"),
        authorities: @app_authorize_info.fetch("func_info").map do |e|
          e["funcscope_category"]["id"]
        end
      }
    end

    def encrypted_message
      xml_data = request.body.read
      data = Hash.from_xml(xml_data)["xml"]
      data["Encrypt"]
    end

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
        #{ENV["SERVER_HOST"]}/api/v1/wechats/authorized_callback?
        company_id=#{company_id}
      URL

      wechat_authorization_url = <<-URL.strip_heredoc.delete("\n")
        https://mp.weixin.qq.com/cgi-bin/componentloginpage?
        component_appid=#{wechat_id}
        &pre_auth_code=#{preauth_code}
        &redirect_uri=#{callback_url}
      URL

      @prime_authorization_url = <<-URL.strip_heredoc.delete("\n")
        #{ENV["SERVER_HOST"]}/api/v1/wechats/pre_auth?
        url=#{CGI.escape(wechat_authorization_url)}
      URL
    end
  end
end
