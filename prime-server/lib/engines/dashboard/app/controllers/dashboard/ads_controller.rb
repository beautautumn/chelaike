module Dashboard
  class AdsController < ApplicationController
    before_action :find_ad, only: [:edit, :update, :destroy]
    before_action do
      authorize :dashboard_ad
    end

    def index
      #return @ads = Advertisement.none.page(0) unless search?
      @ads = Advertisement.ransack(params[:q])
                          .result
                          .order(:id)
                          .page(params[:page])
                          .per(20)
      @counter = Advertisement.ransack(params[:q]).result.count
    end

    def create
      Advertisement.create(ad_params)
      redirect_to ads_path, status: 303
    end

    def edit
      @ad
    end

    def update
      @ad.update(ad_params)
      redirect_to ads_path, status: 303
    end

    def destroy
      @ad.destroy
      redirect_to ads_path, status: 303
    end

    private

    def find_ad
      @ad = Advertisement.find(params[:id])
    end

    def ad_params
      params.require(:ad).permit(:title, :image_url, :redirect_url, :state, :show_seconds)
    end
  end
end
