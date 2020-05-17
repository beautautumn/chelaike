module EasyLoanAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!
    current_user
  rescue EasyLoan::User::Unauthorized
    unauthorized_error
  rescue EasyLoan::User::SingleLoginError => e
    unauthorized_error(e.message)
  end

  def current_user
    return @current_user if @current_user
    current_token_valid?
  end

  def current_token_valid?
    phone, current_device_number, user_token = parse_token
    @current_user = EasyLoan::User.find_by_phone!(phone)

    if @current_user.current_device_number != current_device_number
      raise EasyLoan::User::SingleLoginError, "账号在另一台手机上登录，请重新登录"
    end

    verify_token!(user_token) ? @current_user : (raise EasyLoan::User::Unauthorized, "Token认证失败")
  end

  def verify_token!(user_token)
    @current_user && (@current_user.jwt_token == user_token)
  end

  def parse_token
    user_token = request_header_or_param("autobotstoken")
    begin
      token = user_token.match(/AutobotsAuth (.*)/).captures.first
    rescue
      raise EasyLoan::User::Unauthorized, "Token解析失败"
    end

    payload = Util::JwtService.decode(token)
    [payload.fetch("phone"), payload.fetch("current_device_number"), user_token]
  end

  def request_header_or_param(key)
    request.headers[key] || params[key]
  end
end
