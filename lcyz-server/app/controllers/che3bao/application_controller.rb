module Che3bao
  class ApplicationController < ActionController::API
    include ActionController::Serialization
    include ErrorResponse

    before_action :authenticate_company!

    def authenticate_company!
      unauthorized_error unless current_company
    end

    def current_company
      return @current_company if @current_company

      @current_company = Company.find_by(md5_name: (params["accessToken"] || ""))

      @current_company || false
    end
  end
end
