module AuthenticationHelper
  %w(get post delete put patch).each do |method|
    define_method("auth_#{method}") do |path, params = {}, headers = {}|
      headers.each { |key, value| request.headers[key] = value }
      request.headers["AutobotsToken"] = current_user.token

      send method, path, params, headers.merge!("AutobotsToken" => current_user.token)
    end
  end

  %w(get post delete put patch).each do |method|
    define_method("open_#{method}") do |path, params = {}, headers = {}|
      headers.each { |key, value| request.headers[key] = value }
      request.headers["AutobotsOpenToken"] = current_company.token

      send method, path, params,
           headers.merge!("AutobotsOpenToken" => current_company.token)
    end
  end

  %w(get post delete put patch).each do |method|
    define_method("loan_auth_#{method}") do |path, params = {}, headers = {}|
      headers.each { |key, value| request.headers[key] = value }

      payload = {
        phone: current_user.phone,
        current_device_number: current_user.current_device_number
      }

      jwt = Util::JwtService.encode(payload)
      token = "AutobotsAuth #{jwt}"
      request.headers["autobotstoken"] = token

      send(method, path, params, headers.merge!("autobotstoken" => token))
    end
  end

  def current_user
    @current_user || raise("用户未登录")
  end

  def login_user(user)
    @current_user = user
  end

  def current_company
    @current_company || raise("app未授权")
  end

  def access_app(company)
    @current_company = company
  end

  def give_authority(user, *authorities)
    user.update_columns(
      authorities: user.authorities + authorities
    )
  end

  def deprive_authority(user, *authorities)
    user.update_columns(
      authorities: user.authorities - authorities
    )
  end
end
