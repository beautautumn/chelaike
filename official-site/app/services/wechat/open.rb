# frozen_string_literal: true
# 微信开放平台 OAuth 操作
# See: https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419318590&token=&lang=zh_CN

# 需要注意的是，公众号和用户的 access_token, refresh_token 不同

module Wechat
  class Open
    extend Request
    extend Component

    class << self
      # 发起 OAUTH 请求
      def oauth_url(tenant, silent = true, callback_url = nil, state = "")
        # slient 静默认证, 使用 snsapi_base 只获取 code
        # snsapi_userinfo 如果用户没有关注过公众号，就会弹认证页面
        scope = silent ? "snsapi_base" : "snsapi_userinfo"
        # 默认的回调 URL
        callback_url ||= CGI.escape("http://#{ENV.fetch("SERVER_HOST")}/wechats/#{tenant.id}/oauth_callback")
        # state 可以自定义参数, 这里用于保存跳转验证之前的 URL 以供返回
        encoded_state ||= CGI.escape(state) if state.present?
        <<-URL.strip_heredoc.delete("\n")
          https://open.weixin.qq.com/connect/oauth2/authorize?
          appid=#{tenant.app.app_id}&
          redirect_uri=#{callback_url}&
          scope=#{scope}&
          response_type=code&
          state=#{encoded_state}&
          component_appid=#{WECHAT_ID}
          #wechat_redirect
        URL
      end

      # 获得 code 之后，换取当前用户对当前公众号的 access_token
      def oauth_callback(tenant, code)
        url = <<-URL.strip_heredoc.delete("\n")
          https://api.weixin.qq.com/sns/oauth2/component/access_token?
          appid=#{tenant.app.app_id}&
          code=#{code}&
          grant_type=authorization_code&
          component_appid=#{WECHAT_ID}&
          component_access_token=#{Wechat::App.component_access_token}
        URL

        data = wechat_get(url)
        # 用户 access_token 过期
        # refresh_token() if data["errcode"] == "42001"
        if data["errcode"].present? || data["access_token"].nil?
          Rails.logger.info "ERR: #{data}"
          if data["errcode"].to_s == "40163" || data["errcode"].to_s == "40029"
            data = Rails.cache.read("#{tenant.app&.app_id}-#{code}")
            Rails.logger.info "INFO: data from cache: #{data}"
            return nil unless data.present?
          else
            return nil
          end
        end
        # 缓存公众号用户 access_token
        Rails.cache.fetch("#{USER_ACCESS_TOKEN_KEY}:"\
          "#{tenant.app.app_id}:#{data["openid"]}",
                          expires_in: 6000.seconds) do
          data["access_token"]
        end

        # 缓存 code 获取的信息
        Rails.cache.write("#{tenant.app&.app_id}-#{code}", data, expires_in: 1.minute)

        current_user = set_wechat_app_user(tenant, data)
        get_user_detail(current_user)
        current_user
      end

      def refresh_token(tenant, refresh_token)
        <<-URL.strip_heredoc.delete("\n")
          https://api.weixin.qq.com/sns/oauth2/component/refresh_token?
          appid=#{tenant.app.app_id}&
          grant_type=refresh_token&
          component_appid=#{WECHAT_ID}&
          component_access_token=#{WECHAT_TOKEN}&
          refresh_token=#{refresh_token}
        URL
      end

      # { "access_token" => "AAA",
      #   "expires_in"=>7200,
      #   "refresh_token"=>"bbb",
      #   "openid" => "ccc",
      #   "scope"=>"snsapi_base",
      #   "unionid"=>"DDD" }
      def set_wechat_app_user(tenant, data)
        # 创建用户
        user = WechatUser.find_or_create_by!(union_id: data["unionid"])
        # 创建公众号用户
        user.wechat_app_user_relations.find_or_create_by!(
          wechat_app: tenant.app,
          open_id: data["openid"]
        ) do |app_user|
          # 每次访问更新 refresh_token
          app_user.update!(refresh_token: data["refresh_token"])
        end
      rescue ActiveRecord::RecordNotUnique # 并发
        retry
      end

      # 获取用户详细信息
      # {
      #   "open_id": "AA",
      #   "wechat_app_id": "BB",
      #   "subscribed": 1,
      #   "nick_name": "CC",
      #   "gender": "male",
      #   "city": "",
      #   "province": "DD",
      #   "country": "EE",
      #   "avatar": "FF",
      #   "note": "",
      #   "group_code": 0,
      #   "unionid": "GG",
      #   "created_at": "2017-03-12 02:42:07",
      #   "updated_at": "2017-03-12 02:42:07"
      # }
      def get_user_detail(current_user)
        user_hash = Wechat::Mp::User.detail(
          current_user.app_id, current_user.open_id
        )

        user = WechatUser.find_by(union_id: user_hash[:unionid])

        user.update(
          nick_name: user_hash[:nick_name],
          gender: user_hash[:gender],
          city: user_hash[:city],
          province: user_hash[:province],
          country: user_hash[:country],
          avatar: user_hash[:avatar],
          note: user_hash[:note]
        )

        current_user.update(
          group_id: user_hash[:group_code],
          subscribed: user_hash[:subscribed]
        )
      end
    end
  end
end
