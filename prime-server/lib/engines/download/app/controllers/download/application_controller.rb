module Download
  class ApplicationController < ActionController::Base
    def current_app
      @current_app ||= App.find_by!(domain: request.host)
    end
    helper_method :current_app
  end
end
