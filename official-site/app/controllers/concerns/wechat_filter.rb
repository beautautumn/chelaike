# frozen_string_literal: true
# 微信验证
module WechatFilter
  extend ActiveSupport::Concern
  include UserAgentConcern
  include TenantFilter

  included do
    helper_method :current_user

    def self.ensure_wechat_login
      before_action :current_wechat_app_user
    end
  end

  def current_user
    current_wechat_app_user
  end

  def current_wechat_app_user
    # 非微信环境，判断 cookie 中是否有 open_id
    unless @device_detect_helper.wechat?
      open_id_token = cookies[:open_id].try(:to_sym)
      @current_user = Wechat::DesktopAuth.set_user open_id_token
      @wechat_user = @current_user&.wechat_user
      return @current_user
    end
    # 如果没配微信
    return redirect_to invalid_path unless @tenant.app.present?
    # 当前公众号对应的用户
    # 微信回调的 code 就是 OpenID
    open_id = session["open_id"] || params[:code]
    # 保存当前访问路径到 state 以便回调后返回
    # 如果是 "/" 首页就不用保存
    # 为防止 URL 超长，用 Chelaike::Util.shorten_url 做一次转换
    short_url = if request.original_fullpath == "/"
                  nil
                else
                  Chelaike::Util.shorten_url request.original_url
                end

    @current_user = WechatAppUserRelation.find_by(open_id: open_id) if open_id.present?
    return redirect_to Wechat::Open.oauth_url(@tenant, false, nil, short_url) unless open_id.present? && @current_user.present?
    @wechat_user = @current_user&.wechat_user
    # 用户 ID 写入 session
    session["union_id"] = @current_user.union_id
    session["open_id"] = @current_user.open_id
    @current_user
  end
end
