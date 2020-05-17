module V1
  module AllianceDashboard
    class ApplicationController < ActionController::API
      include Authentication
      include ErrorCollector::Handler
      include Pundit
      include ErrorResponse

      def basic_params_validations
        param! :order_by, String, in: %w(asc desc), default: "desc"
        param! :query, Hash
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 25
      end

      def current_token_valid?
        user_id, user_token = current_token

        @current_user = AllianceCompany::User.find_by(id: user_id, state: "enabled")
        verify_token!(user_token) ? @current_user : (raise User::Unauthorized, "Token认证失败")
      end
    end
  end
end
