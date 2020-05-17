module Download
  class HomeController < ApplicationController
    def index
      @app_alias = current_app.alias
      @latest_version = if params[:id]
                          current_app.app_versions.find(params[:id])
                        else
                          current_app.latest_version("production")
                        end
    end
  end
end
