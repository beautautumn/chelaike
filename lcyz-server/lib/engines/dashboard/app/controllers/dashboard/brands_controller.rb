module Dashboard
  class BrandsController < ApplicationController
    before_action do
      authorize :dashboard_brand
    end

    def index
      @brands = Megatron.brands["data"]
    end

    def show
      @brand = Megatron.find_brand_by_id(params[:id])["data"]
      @data = Megatron.series(@brand["name"])["data"]
    end

    def edit
      brand = Megatron.find_brand_by_id(params[:id])["data"]
      @brand = OpenStruct.new(brand)
    end

    def create
      Megatron.create_brand(params[:brand])
      redirect_to brands_path
    end

    def update
      Megatron.update_brand(params[:id], params[:brand])
      redirect_to brands_path
    end
  end
end
