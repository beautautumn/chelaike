# 给车容易提供通知接口
module Open
  module V3
    class ApplicationController < ActionController::API
      include ActionController::Serialization
      include ErrorCollector::Handler
      include ErrorResponse

      before_action :authenticate_platform!

      private

      # 验证是否是车容易发过来的请求
      def authenticate_platform!
        request_token = request_header_or_param("OpenAppToken")
        return unauthorized_error("token无效") unless request_token == auth_token
      end

      def auth_token
        ENV["CHERONGYI_TOKEN"]
      end

      def request_header_or_param(key)
        request.headers[key] || params[key]
      end
    end
  end
end
