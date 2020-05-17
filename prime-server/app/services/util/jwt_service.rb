module Util
  module JwtService
    module_function

    def encode(payload)
      JWT.encode payload, Rails.application.secrets[:secret_token], "HS256"
    end

    def decode(token)
      JWT.decode(token, Rails.application.secrets[:secret_token], true, algorithm: "HS256").first
    rescue JWT::VerificationError
      raise EasyLoan::User::Unauthorized
    rescue JWT::DecodeError
      raise EasyLoan::User::Unauthorized
    end
  end
end
