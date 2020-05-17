module Dashboard
  class AppsController < ApplicationController
    before_action do
      authorize :dashboard_app
    end
    before_action :set_app, only: [:edit, :update, :destroy]

    def index
      @apps = App.all
    end

    def new
      @app = App.new
    end

    def create
      @app = App.new(app_params)
      if @app.save
        redirect_to apps_path
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @app.update(app_params)
        redirect_to apps_path
      else
        render :edit
      end
    end

    def destroy
      @app.destroy!
      redirect_to apps_path
    end

    private

    def app_params
      params.require(:app).permit(:name, :alias, :domain, :slogan, :logo, :pc_url)
    end

    def set_app
      @app = App.find(params[:id])
    end
  end
end
