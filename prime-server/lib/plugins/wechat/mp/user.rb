module Wechat
  module Mp
    class User
      extend Request

      class << self
        def all(app_id)
          fetch(app_id)
        end

        def details(app_id, open_ids)
          wechat_app_id = WechatApp.find_by(app_id: app_id).id
          url = <<-URL.strip_heredoc
            https://api.weixin.qq.com/cgi-bin/user/info/batchget?
            access_token=#{Wechat::App.app_access_token(app_id)}
          URL

          open_id_groups = open_ids.each_slice(100).to_a

          open_id_groups.inject([]) do |user_list, group|
            users = group.map { |open_id| { openid: open_id } }
            user_info_list = wechat_post(url, user_list: users)["user_info_list"]

            user_list.concat(user_info_list.map { |user| info(wechat_app_id, user) })
          end
        end

        def detail(app_id, open_id)
          url = <<-URL.strip_heredoc
            https://api.weixin.qq.com/cgi-bin/user/info?
            access_token=#{Wechat::App.app_access_token(app_id)}&
            openid=#{open_id}&lang=zh_CN
          URL
          wechat_app_id = WechatApp.find_by(app_id: app_id).id

          info(wechat_app_id, wechat_get(url))
        end

        private

        def info(app_id, user)
          now = Time.zone.now.to_s(:db)

          {
            open_id: user["openid"],
            wechat_app_id: app_id,
            subscribed: user["subscribe"],
            nick_name: user["nickname"],
            gender: gender(user["sex"]),
            city: user["city"],
            province: user["province"],
            country: user["country"],
            avatar: user["headimgurl"],
            note: user["remark"],
            group_code: user["groupid"],
            unionid: user["unionid"],
            created_at: now,
            updated_at: now
          }
        end

        def fetch(app_id, open_ids = [], next_id = nil)
          url = <<-URL.strip_heredoc
            https://api.weixin.qq.com/cgi-bin/user/get?
            access_token=#{Wechat::App.app_access_token(app_id)}&
          URL
          url << "next_openid=#{next_id}" if next_id

          response = wechat_get(url)
          return unless response["data"] && response["data"]["openid"]

          open_ids.concat(response["data"]["openid"])
          next_id = response["next_openid"]

          if finish?(next_id, open_ids)
            open_ids
          else
            fetch(open_ids, next_id)
          end
        end

        def finish?(next_id, open_ids)
          next_id.nil? || next_id.empty? || open_ids.empty? || next_id == open_ids.last
        end

        def gender(value)
          value == 1 ? "male" : "female"
        end
      end
    end
  end
end
