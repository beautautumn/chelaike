require "upsert/active_record_upsert"

module Wechat
  class AuthorizationService
    def initialize(auth_code, company)
      @auth_code = auth_code
      @company = company
    end

    def execute
      @app_authorize_info = App.authorize_app(@auth_code)["authorization_info"]
      return unless @app_authorize_info

      wechat_app = find_wechat_app
      save_wechat_app(wechat_app)
      App.set_app_access_token(wechat_app.app_id, app_params[:access_token])
      # wechat_users = fetch_users(wechat_app.app_id)
      # batch_upsert_users(wechat_users)
    end

    private

    def save_wechat_app(wechat_app)
      wechat_app.refresh_token = app_params[:refresh_token]
      wechat_app.authorities = app_params[:authorities]
      wechat_app.assign_attributes(Wechat::App.profile(app_params[:app_id]))
      wechat_app.state = "enabled"

      wechat_app.save!
    end

    def find_wechat_app
      @company.wechat_app || new_wechat_app
    end

    def new_wechat_app
      WechatApp.new(app_id: app_params[:app_id], company: @company)
    end

    def fetch_users(wechat_app_id)
      open_ids = Wechat::Mp::User.all(wechat_app_id)
      Wechat::Mp::User.details(wechat_app_id, open_ids)
    end

    def batch_upsert_users(wechat_users)
      wechat_users.each do |user|
        WechatUser.upsert({ open_id: user[:open_id] }, user)
      end
    end

    def app_params
      @app_params ||= {
        app_id: @app_authorize_info["authorizer_appid"],
        access_token: @app_authorize_info["authorizer_access_token"],
        refresh_token: @app_authorize_info["authorizer_refresh_token"],
        authorities: @app_authorize_info["func_info"].map { |e| e["funcscope_category"]["id"] }
      }
    end
  end
end
