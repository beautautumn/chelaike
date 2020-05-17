module Dashboard
  class ParallelStylesController < ApplicationController
    before_action :find_parallel_brand, only: [:index, :create]
    before_action :find_parallel_style, only: [:edit, :update, :destroy]
    before_action do
      authorize :dashboard_parallel_style
    end

    def index
      style_type = params[:type] == "special" ? "special_offer" : "parallel_import"

      @parallel_styles = @parallel_brand.styles
                                        .where(style_type: style_type)
                                        .ransack(params[:q]).result
                                        .order(:id)
                                        .page(params[:page])
                                        .per(20)
      @counter = @parallel_brand.styles
                          .where(style_type: style_type)
                          .ransack(params[:q]).result.count
    end

    def create
      @parallel_brand.styles.create(parallel_style_params)
      redirect_to parallel_brand_parallel_styles_path(@parallel_brand), status: 303
    end

    def edit
      @parallel_style
    end

    def update
      @parallel_style.update(parallel_style_params)
      redirect_to parallel_brand_parallel_styles_path(@parallel_style.brand), status: 303
    end

    def destroy
      @parallel_style.destroy
      redirect_to parallel_brand_parallel_styles_path(@parallel_style.brand), status: 303
    end

    def delete_image
      @parallel_style = ::Parallel::Style.find(params[:style])
      @parallel_style.images.find(params[:image]).destroy!
      redirect_to edit_parallel_style_path(@parallel_style)
    end

    private

    def find_parallel_brand
      @parallel_brand = ::Parallel::Brand.find(params[:parallel_brand_id])
    end

    def find_parallel_style
      @parallel_style = ::Parallel::Style.find(params[:id])
    end

    def parallel_style_params
      if params[:parallel_style][:sell_price_wan].blank?
        params[:parallel_style][:sell_price_wan] = nil
      end

      if params[:parallel_style][:suggested_price_wan].blank?
        params[:parallel_style][:suggested_price_wan] = nil
      end

      params.require(:parallel_style)
            .permit(:name, :origin, :color, :configuration,
                    :status, :suggested_price_wan, :sell_price_wan,
                    images: [])
            .merge(style_type: "parallel_import") # 默认平行进口车
    end
  end
end
