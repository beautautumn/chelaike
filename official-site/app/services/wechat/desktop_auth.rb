module Wechat
  module DesktopAuth
    extend self

    def encode(data = nil)
      hmac_secret = 'my$ecretK3y'
      payload = {
        iss: 'tianche',
        data: data
      }

      token = JWT.encode payload, hmac_secret, 'HS256'
    end

    def verify?(token)
      res = decode token
      res.is_a?(Array) ? true : false
    end

    def set_user open_id_token
      res = decode open_id_token.to_s
      return WechatAppUserRelation.find_by(open_id: res[0]["data"]) if res.is_a?(Array)
      nil
    end

    def parse_token token
      res = decode token
      verify_result = res.is_a?(Array) ? true : false
      data = verify_result ? res[0]["data"] : nil
    end

    private
    def decode(token)
      hmac_secret = 'my$ecretK3y'
      begin
        decoded_token = JWT.decode token, hmac_secret, true, { :algorithm => 'HS256' }
      rescue JWT::VerificationError
        "token_error"
      rescue JWT::DecodeError
        "token_error"
      end
    end
  end
end
