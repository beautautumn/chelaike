module V1
  class AppVersionsController < ApplicationController
    serialization_scope :anonymous

    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def show
      render json: AppVersion.find(params[:id]),
             serializer: AppVersionSerializer::Common,
             root: "data"
    end

    def production
      render json: current_production_app_version(params[:version_category]),
             serializer: AppVersionSerializer::Common,
             root: "data"
    end

    private

    def current_production_app_version(version_category)
      version_category ||= "chelaike"

      app = App.find_by!(alias: version_category)
      app.latest_version("production")
    end
  end
end
