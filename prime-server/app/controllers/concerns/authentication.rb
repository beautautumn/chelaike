module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def current_user
    return @current_user if @current_user

    current_token_valid?
    single_login_valid?

    @current_user.passport = Passport::Info.new(
      current_device_number,
      current_app_version,
      request_header_or_param("AutobotsPlatform"),
      request_header_or_param("AutobotsAppKey")
    )

    @current_user
  end

  def authenticate_user!
    current_user
  rescue User::Unauthorized
    unauthorized_error
  rescue User::SingleLoginError => e
    unauthorized_error(e.message)
  end

  def anonymous
    User::Anonymous.new
  end

  def current_or_anonymous
    request_header_or_param("AutobotsToken").present? ? current_user : anonymous
  end

  def current_mac_address_valid?
    mac_address = request_header_or_param("AutobotsMacAddress")

    return @current_user if @current_user.mac_address_valid?(mac_address)

    raise User::Unauthorized, "MAC地址认证失败."
  end

  def current_device_number_valid?
    return @current_user if @current_user.device_number_valid?(current_device_number)

    raise User::Unauthorized, "设备号认证失败."
  end

  def current_token_valid?
    user_id, user_token = current_token

    @current_user = User.find_by(id: user_id, state: "enabled")

    verify_token!(user_token) ? @current_user : (raise User::Unauthorized, "Token认证失败")
  end

  def verify_token!(user_token)
    @current_user && (
      @current_user.token == user_token || @current_user.simple_token == user_token
    )
  end

  def current_token
    user_token = request_header_or_param("AutobotsToken")

    begin
      token = user_token.match(/AutobotsAuth (.*)/).captures.first
    rescue
      raise User::Unauthorized, "Token解析失败"
    end

    user_id = JWT.decode(token, Rails.application.secrets[:secret_token])
                 .first.fetch("user_id")

    [user_id, user_token]
  end

  def current_device_number
    @_device_number ||= request_header_or_param("AutobotsDeviceNumber")
  end

  def current_app_version
    @_app_version ||= request_header_or_param("AutobotsMobileAppVersion")
  end

  def request_header_or_param(key)
    request.headers[key] || params[key]
  end

  # 检查单机登录是否合法
  def single_login_valid?
    platform = request_header_or_param("AutobotsPlatform").try(:downcase)
    return unless platform.in?(%w(ios android))
    req_device_num = request_header_or_param("AutobotsDeviceNumber")
    device_num_match = @current_user.current_device_number == req_device_num
    raise User::SingleLoginError, "账号在另一台手机上登录，请重新登录" unless device_num_match
  end
end
