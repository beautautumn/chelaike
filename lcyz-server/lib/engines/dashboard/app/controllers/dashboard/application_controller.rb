module Dashboard
  class ApplicationController < ActionController::Base
    include Pundit

    before_action :authenticate_staff!
    after_action :verify_authorized

    def search?
      !current_staff.customer_service? ||
        (params[:q].present? && !params[:q].empty?)
    end

    def authenticate_staff!
      redirect_to new_session_path unless current_staff
    end

    def current_staff
      @current_staff ||= Staff.find_by(id: session[:staff_id], state: "enabled")
    end

    helper_method :current_staff

    def pundit_user
      current_staff
    end

    def current_staff?(staff)
      current_staff==staff
    end

    rescue_from Pundit::NotAuthorizedError do |_exception|
      render text: "权限不足"
    end
  end
end
