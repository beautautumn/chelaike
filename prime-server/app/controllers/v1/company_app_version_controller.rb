module V1
  class CompanyAppVersionController < ApplicationController
    before_action :skip_authorization

    def show
      app_version = current_company.current_app_version(params[:version_category])

      return render(json: {}, scope: nil) unless app_version
      render json: app_version,
             serializer: AppVersionSerializer::Common,
             root: "data"
    end

    private

    def current_company
      current_user.company
    end
  end
end
