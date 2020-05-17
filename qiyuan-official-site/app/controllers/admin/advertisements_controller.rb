# frozen_string_literal: true
class Admin::AdvertisementsController < Admin::ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]
  before_action :set_platform
  helper_method :params

  def index
    @advertisements = current_tenant.advertisements
                                    .with_platform(params[:platform])
  end

  def new
    @advertisement = current_tenant.advertisements.new
  end

  def create
    @advertisement = current_tenant.advertisements.create(advertisement_params)
    @advertisement.save
    redirect_to admin_advertisements_path(
      platform: params[:advertisement][:platform]
    ), status: 303
  end

  def show; end

  def edit; end

  def update
    @advertisement.update(advertisement_params)
    redirect_to admin_advertisements_path(
      platform: params[:advertisement][:platform]
    ), status: 303
  end

  def destroy
    platform = @advertisement.platform
    @advertisement.destroy
    redirect_to admin_advertisements_path(platform: platform), status: 303
  end

  private

  def set_advertisement
    @advertisement = current_tenant.advertisements.find(params[:id])
  end

  def advertisement_params
    params.require(:advertisement)
          .permit(:ad_type, :image_url, :link, :platform)
  end

  def set_platform
    param! :platform, String, in: %w(mobile desktop)
  end
end
