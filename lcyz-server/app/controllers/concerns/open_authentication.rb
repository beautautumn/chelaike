module OpenAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_app!
  end

  def current_company
    return @current_company if @current_company
    if request_header_or_param("AutobotsOpenToken").present?
      current_token_valid?
    else
      fetch_company_by_id
    end
  end

  def authenticate_app!
    current_company
  rescue Company::Unauthorized => e
    unauthorized_error(e.message)
  end

  def current_token_valid?
    id = current_token["id"]
    expired_at = current_token["expired_at"]

    raise(Company::Unauthorized, "token已过期") if Time.zone.now >= expired_at

    # 官网获取公司/联盟列表时, 无需 company id
    @current_company = Company.find(id) unless id.nil?
  end

  def current_token
    token = request_header_or_param("AutobotsOpenToken")

    begin
      JWT.decode(token, ENV.fetch("OPEN_APP_SECRET"), true, algorithm: "HS256")
         .first
    rescue
      raise Company::Unauthorized, "token解密失败"
    end
  end

  def fetch_company_by_id
    company_id = request_header_or_param("company_id")

    raise Company::Unauthorized if company_id.blank?

    @current_company = Company.find(company_id)
  end

  def request_header_or_param(key)
    request.headers[key] || params[key]
  end
end
