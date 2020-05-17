module V1
  class SeriesController < ApplicationController
    def index
      if params[:series]
        series = Series.find_by(name: params[:series][:name])

        render json: { data: series }
      else
        brand_code = Brand.find_by(name: brand_params[:name]).code

        series = Series.collection.aggregate(aggregate_condition(brand_code))

        render json: { data: series }
      end
    end

    def show
      series = Series.find(params[:id])
      render json: { data: series }
    end

    def update
      series = Series.find(params[:id])
      data = series.update_attributes(series_params)

      render json: { data: data }
    end

    def create
      data = Series.create!(series_params)

      render json: { data: data }
    end

    private

    def aggregate_condition(brand_code)
      [
        {
          "$match" => {
            "brand_code" => brand_code
          }
        },
        {
          "$sort" => {
            "manufacturer" => -1,
            "name" => 1
          }
        },
        {
          "$group" => {
            "_id" => "$manufacturer",
            "series" => {
              "$push" => { name: "$name", _id: "$_id", code: "$code" }
            }
          }
        },
        {
          "$project" => {
            "_id" => false,
            "manufacturer_name" => "$_id",
            "series" => "$series"
          }
        }
      ]
    end

    def brand_params
      params.require(:brand).permit(:name)
    end

    def series_params
      params.require(:series).permit(:name, :code, :manufacturer, :brand_code)
    end
  end
end
