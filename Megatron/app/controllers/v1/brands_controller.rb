module V1
  class BrandsController < ApplicationController
    def index
      if brand_params[:name]
        brand = Brand.find_by(name: brand_params[:name])

        render json: { data: brand }
      elsif series_params[:name]
        brand_code = Series.find_by(name: series_params[:name]).brand_code
        brand = Brand.find_by(code: brand_code)

        render json: { data: brand }
      else
        brands = Brand.all.order(first_letter: :asc).only(:name, :first_letter, :code, :_id)

        render json: { data: brands }
      end
    end

    def show
      brand = Brand.find(params[:id])
      render json: { data: brand }
    end

    def update
      brand = Brand.find(params[:id])
      data = brand.update_attributes(brand_params)

      render json: { data: data }
    end

    def create
      data = Brand.create!(brand_params)

      render json: { data: data }
    end

    private

    def brand_params
      return params.require(:brand).permit(:name, :first_letter, :code) if params[:brand]

      {}
    end

    def series_params
      return params.require(:series).permit(:name) if params[:series]

      {}
    end
  end
end
