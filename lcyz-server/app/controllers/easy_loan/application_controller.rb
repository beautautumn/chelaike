class EasyLoan::ApplicationController < ActionController::API
  include ActionController::Serialization
  include ErrorCollector::Handler
  include Pundit
  include ErrorResponse
  include EasyLoanAuthentication

  before_action :set_headers

  rescue_from(ActiveRecord::RecordNotFound) do |err|
    not_found(err.message)
  end

  rescue_from(ActiveRecord::RecordInvalid) do |e|
    validation_error(e.message)
  end

  rescue_from Yunpian::RequestException do |err|
    render json: { error: "YunpianErr", message: err.to_s },
           scope: nil, status: 400,
           root: "data"
  end

  rescue_from(EasyLoan::User::TokenExpired) do |err|
    forbidden_error(err.message)
  end

  def forbidden_error(message = nil)
    render(status: 403, json: { message: message || "操作权限不足" }, scope: nil, root: "data")
  end

  def unauthorized_error(message = nil)
    render(status: 401, json: { message: message || "认证未通过" }, scope: nil, root: "data")
  end

  def basic_params_validations
    param! :order_by, String, in: %w(asc desc), default: "desc"
    param! :query, Hash
    param! :page, Integer, default: 1
    param! :per_page, Integer, default: 25
  end

  protected

  def set_headers
    headers["Content-Type"] = "application/json; charset=UTF-8"
  end
end
