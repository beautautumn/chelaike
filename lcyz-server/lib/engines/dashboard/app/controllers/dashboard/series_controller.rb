module Dashboard
  class SeriesController < ApplicationController
    before_action do
      authorize :dashboard_series
    end

    def index
      @series = Megatron.series["data"]
    end

    def edit
      @brand = Megatron.find_brand_by_id(params[:brand_id])["data"]
      series = Megatron.find_series_by_id(params[:id])["data"]
      @series = OpenStruct.new(series)
    end

    def create
      @brand = Megatron.find_brand_by_id(params[:series][:brand_id])["data"]
      Megatron.create_series(series_params)
      redirect_to brand_path(@brand["_id"])
    end

    def update
      @brand = Megatron.find_brand_by_id(params[:series][:brand_id])["data"]
      Megatron.update_series(params[:id], series_params)
      redirect_to brand_path(@brand["_id"])
    end

    def show
      @brand = Megatron.find_brand_by_id(params[:brand_id])["data"]
      @series = Megatron.find_series_by_id(params[:id])["data"]
      @styles = Megatron.styles(@series["name"])["data"]
    end

    private

    def series_params
      params.require(:series).permit(:brand_code, :code, :manufacturer, :name)
    end
  end
end
