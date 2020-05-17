module ErrorResponse
  extend ActiveSupport::Concern
  include ActiveSupport::Rescuable::ClassMethods

  included do
    rescue_from RailsParam::Param::InvalidParameterError,
                ActionController::ParameterMissing,
                Pingpp::InvalidRequestError do |exception|
      bad_request("参数字段有错误", exception)
    end

    rescue_from Encoding::UndefinedConversionError do |exception|
      bad_request("编码有误", exception)
    end

    rescue_from Pundit::NotAuthorizedError do |_exception|
      forbidden_error
    end

    rescue_from Timeout::Error do |_exception|
      render(status: 408, json: { message: "Timeout" }, scope: nil)
    end

    rescue_from ActiveRecord::RecordNotFound, RestClient::ResourceNotFound do |_exception|
      not_found
    end

    rescue_from CheJianDing::BuyError do |exception|
      m = JSON.parse exception.message
      render(status: 422, json: { status: m["status"].to_i, message: m["message"] }, scope: nil)
    end
  end

  def bad_request(message, exception)
    render status: 400,
           json: {
             message: message,
             errors: MultiJson.load(exception.to_json)
           },
           scope: nil
  end

  def not_found(message = nil)
    render(status: 404, json: { message: message || "404 未找到指定资源" }, scope: nil)
  end

  def validation_error(errors)
    hash = {
      message: "参数校验不通过",
      errors: errors
    }

    render(json: hash, status: 422, scope: nil)
  end

  def forbidden_error(message = nil)
    render(status: 403, json: { message: message || "操作权限不足" }, scope: nil)
  end

  def unauthorized_error(message = nil)
    render(status: 401, json: { message: message || "认证未通过" }, scope: nil)
  end

  def already_accepted(message: nil)
    render(status: 202, json: { message: message || "正在处理中" }, scope: nil)
  end

  def payment_required(message: nil)
    render(status: 402, json: { message: message || "需要购买" }, scope: nil)
  end
end
