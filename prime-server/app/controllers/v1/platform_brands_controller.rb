class V1::PlatformBrandsController < ApplicationController
  before_action :skip_authorization
  # skip_before_action :authenticate_user!, except: [:brands]
  def brands
    param! :platform_code, Integer, required: true

    brands = PlatformBrand.get_platform_brands params[:platform_code], params[:is_text]
    render  json: brands,
            each_serializer: PlatformBrandSerializer::Brand,
            root: "data"
  end
end
