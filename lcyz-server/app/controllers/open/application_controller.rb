module Open
  class ApplicationController < ActionController::API
    include ActionController::Serialization
    include ErrorCollector::Handler
    include ErrorResponse
    include OpenAuthentication

    def current_company_cars
      if current_company.open_alliance.present? && !params[:without_allied]
        return current_company.open_allied_cars
      else
        current_company.cars
      end
    end

    def version_catagory(catagory = "chelaike")
      I18n.t("version_catagory.#{catagory}")
    end
  end
end
