# frozen_string_literal: true
class WechatsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :current_tenant, only: [:authorization, :pre_auth, :authorize_callback,
    :authorized_callback, :events_callback, :oauth, :oauth_callback]

  # 使用第三方平台公众号授权的方式扫码登录
  def new
    @token = Wechat::DesktopAuth.encode
    Rails.cache.write(@token, @token, expires_in: 10.minutes )
    @qr_code = Chelaike::Util.shorten_url Wechat::Open.oauth_url(@tenant, false, nil, @token)
  end

  def destroy
    token = cookies[:open_id]
    if Wechat::DesktopAuth.verify? token
      cookies.permanent[:open_id] = ""
      redirect_to root_path, notice: "退出" and return
    else
      redirect_to root_path, notice: "失败" and return
    end
  end

  def scaned
    render text: "授权登录成功，请关闭此页面并返回 PC 端操作"
  end

  def login_loop_query
    open_id = Rails.cache.read(params[:token])
    @current_user = WechatAppUserRelation.find_by(open_id: open_id)
    if @current_user
      @wechat_user = @current_user&.wechat_user
      cookies.permanent[:open_id] = Wechat::DesktopAuth.encode(@current_user.open_id)
      render json: { content: root_url, status: 200}
    else
      render json: { content: "nothing", status: 400}
    end
  end

  # 引导用户授权公众号给开放平台
  # http://site.chelaike.com/wechats/2/authorization
  def authorization
    @tenant = Tenant.find(params[:id])
    @tenant.host = "http://#{ENV.fetch("SERVER_HOST")}"
    @app = @tenant.app
    @url = if @app && @app.state.enabled?
             nil
           else
             generate_authorization_url
           end
    render :authorization
  end

  def pre_auth
    @preauth_url = CGI.escape(params[:url])
    render :pre_auth
  end

  # 接收微信服务器推送的 component_verify_ticket
  def authorize_callback
    Wechat::App.set_component_verify_ticket(params, encrypted_message)

    render text: "success"
  end

  # 授权完成回调
  def authorized_callback
    @tenant = Tenant.find(params[:tenant_id])
    Wechat::AuthorizationService.new(
      params[:auth_code], @tenant
    ).execute

    unless @tenant.wechat_app.verify_service?
      return render text: "已授权到车来客平台。但您的公众号不是已认证服务号，如需使用更多个性化功能，请联系管理员开通微信认证。"
    end

    render text: "授权成功。车来客已接管应用，感谢您对车来客的支持。"
  end

  # 事件回调
  def events_callback
    @wechat_app = WechatApp.find_by(app_id: params[:id])
    reply = Wechat::Reducer.execute(params[:id], params, encrypted_message)
    if reply
      render xml: reply
    else
      render text: "success"
    end
  end

  # 发起 OAuth 授权
  def oauth
    if @app && @app.state.enabled?
      redirect_to Wechat::Open.oauth_url(@tenant, false)
    else
      render :oauth_error
    end
  end

  # OAuth 回调
  def oauth_callback
    # http://site.chelaike.com/wechats/12694/oauth_callback?code=001YLRrX1JNRNU0op6sX1m0JrX1YLRrv&state=http%3A%2F%2Fw.url.cn%2Fs%2FA8QfZAg&appid=wxbe6ec1b410f661f2
    # 获取用户 access_token 并缓存
    Wechat::App.component_access_token
    @tenant ||= Tenant.find(params[:id])

    @current_user = Wechat::Open.oauth_callback(@tenant, params[:code])
    session[:union_id] = @current_user.union_id
    session[:open_id] = @current_user.open_id
    previous_path = CGI.unescape(params[:state]) if params[:state].present?
    previous_path&.gsub!(/^\//, "") # removing leading slash, convert '/' to nil
    # PC 端扫码登录功能，微信客户端跳转到提示页面
    if Wechat::DesktopAuth.verify? params[:state]
      Rails.cache.write(params[:state], @current_user.open_id, expires_in: 10.minutes )
      return redirect_to "http://#{@tenant.subdomain}.#{ENV.fetch("SERVER_HOST")}/wechats/scaned"
    end

    previous_url = if previous_path.present?
                     # http://8634.site.chelaike.com/cars/393520?seller_id=33477&shared_from=true&from=groupmessage&isappinstalled=1&code=omSoftzWaIymoilDL05IVrTsjBXk
                     "#{previous_path}"\
                     "?code=#{@current_user.open_id}"
                   else
                     # http://chuche.site.chelaike.com/?code=omSoft5nw7VHYBWj3gf_hujvUheI
                     "http://#{@tenant.subdomain}."\
                     "#{ENV.fetch("SERVER_HOST")}"\
                     "?code=#{@current_user.open_id}"
                   end
    redirect_to previous_url
  end

  private

  def encrypted_message
    xml_data = request.body.read
    data = Hash.from_xml(xml_data)["xml"]
    data["Encrypt"]
  end

  def generate_authorization_url
    wechat_id = Wechat::WECHAT_ID
    preauth_code = Wechat::App.preauth_code
    callback_url = <<-URL.strip_heredoc.delete("\n")
      #{@tenant.host}/wechats/authorized_callback?
      tenant_id=#{@tenant.id}
    URL

    wechat_authorization_url = <<-URL.strip_heredoc.delete("\n")
      https://mp.weixin.qq.com/cgi-bin/componentloginpage?
      component_appid=#{wechat_id}
      &pre_auth_code=#{preauth_code}
      &redirect_uri=#{callback_url}
    URL

    @prime_authorization_url = <<-URL.strip_heredoc.delete("\n")
      #{@tenant.host}/wechats/pre_auth?
      url=#{CGI.escape(wechat_authorization_url)}
    URL
  end

  def oauth_callback_url
    CGI.escape("#{@tenant.host}/wechats/oauth_callback")
  end
end
