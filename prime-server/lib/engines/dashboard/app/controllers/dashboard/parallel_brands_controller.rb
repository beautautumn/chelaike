module Dashboard
  class ParallelBrandsController < ApplicationController
    before_action :find_parallel_brand, only: [:edit, :update, :destroy]
    before_action do
      authorize :dashboard_parallel_brand
    end

    def index
      brand_type = params[:type] == "special" ? "special_offer" : "parallel_import"

      @parallel_brands = ::Parallel::Brand.where(brand_type: brand_type)
                                          .ransack(params[:q]).result
                                          .order(:id)
                                          .page(params[:page])
                                          .per(20)
      @counter = ::Parallel::Brand.where(brand_type: brand_type)
                        .ransack(params[:q])
                        .result
                        .count
    end

    def create
      ::Parallel::Brand.create(parallel_brand_params)
      redirect_to parallel_brands_path, status: 303
    end

    def edit
      @parallel_brand
    end

    def update
      @parallel_brand.update(parallel_brand_params)
      redirect_to parallel_brands_path, status: 303
    end

    def destroy
      @parallel_brand.destroy
      redirect_to parallel_brands_path, status: 303
    end

    private

    def find_parallel_brand
      @parallel_brand = ::Parallel::Brand.find(params[:id])
    end

    def parallel_brand_params
      params.require(:parallel_brand)
            .permit(:name, :logo_url)
            .merge(brand_type: "parallel_import") # 默认平行进口车
    end
  end
end
