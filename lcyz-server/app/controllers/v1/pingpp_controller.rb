# https://github.com/PingPlusPlus/pingpp-ruby/blob/master/example/webhooks.rb
module V1
  class PingppController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def notify
      if request.headers[:HTTP_X_PINGPLUSPLUS_SIGNATURE].nil?
        return response.status = 401
      end
      raw_data = request.body.read
      signature = request.headers[:HTTP_X_PINGPLUSPLUS_SIGNATURE]

      pub_key_path = Rails.root.to_s + "/config/pingpp/pingpp_rsa_public_key.pem"
      if verify_signature(raw_data, signature, pub_key_path)
        event_process
      else
        response.status = 403
      end
    end

    private

    def event_process
      status = 400
      response_body = ""
      begin
        case params[:type]
        when nil
          response_body = "Event 对象中缺少 type 字段"
        when "charge.succeeded"
          order_success
          status = 200
          response_body = "OK"
        else
          response_body = "未知 Event 类型"
        end
      rescue JSON::ParserError
        response_body = "JSON 解析失败"
      end
      response.body = response_body
      response["Content-Type"] = "text/plain; charset=utf-8"
      response.status = status
    end

    def verify_signature(raw_data, signature, pub_key_path)
      rsa_public_key = OpenSSL::PKey.read(File.read(pub_key_path))
      rsa_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), raw_data)
    end

    def order_success
      order_no = params[:data][:object][:order_no]
      order = Order.find_by_id(order_no)

      return unless order && order.status.charge?

      token = Token.associated_order(order)
      service = TokenService::Income.new(token)

      service.charge(order)
    end
  end
end
