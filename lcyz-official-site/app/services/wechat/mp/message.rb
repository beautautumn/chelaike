# frozen_string_literal: true
module Wechat
  module Mp
    class Message
      extend Request

      class << self
        def text(app_id, open_id, content)
          reply app_id, touser: open_id, msgtype: "text", text: { content: content }
        end

        def articles(app_id, open_id, content)
          reply app_id, touser: open_id, msgtype: "news", news: { articles: content }
        end

        private

        def reply(app_id, data)
          url = <<-URL.strip_heredoc
            https://api.weixin.qq.com/cgi-bin/message/custom/send?
            access_token=#{App.app_access_token(app_id)}
          URL

          wechat_post(url, data)
        end
      end
    end
  end
end
