class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Pundit
  include ErrorCollector::Handler
  include ErrorResponse
  include Authentication
  include KeywordRecordable

  after_action :verify_authorized

  def basic_params_validations
    param! :order_by, String, in: %w(asc desc), default: "desc"
    param! :query, Hash
    param! :page, Integer, default: 1
    param! :per_page, Integer, default: 25
  end
end
