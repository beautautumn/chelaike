# frozen_string_literal: true
class HomeController < ApplicationController
  change_view_by_device
  ensure_wechat_login
  skip_before_action :verify_authenticity_token, only: [:condition_search, :search_page]

  def index
    if device_detect_helper.mobile?
      @ads = @tenant.advertisements
                    .where(platform: "mobile", ad_type: "level_1")

      @mid_banner = @tenant.advertisements
                           .find_by(platform: "mobile", ad_type: "level_2")
    else
      all_brands = Chelaike::BrandService.fetch_brands(@tenant.combination_id)
      @hot_brands = all_brands.take(5)
      @group_brands = group_brands(all_brands)
      @top_banner = @tenant.advertisements
                           .find_by(platform: "desktop", ad_type: "level_1") ||
                    Advertisement.find_by(id: 0)
      @mid_banner = @tenant.advertisements
                           .find_by(platform: "desktop", ad_type: "level_2")

    end

    @onsale_cars = load_onsale_cars

    recommended_ids = @tenant.recommended_cars.pluck(:car_id)
    @recommended_cars = Chelaike::CarService.fetch_by_ids(recommended_ids, @tenant.company_id)

    request_params = { per_page: 8 }
    result = Chelaike::CarService.query(request_params, @tenant.combination_id)
    current_seller
    @cars_count = result.total
    @selling_cars = result.data

    return if @tenant.tenant_type == "company"
    @alliance_name = @tenant.company.name
    @alliance_cars_count = @tenant.company.cars_count
    @alliance_main_site = alliance_main_site(@tenant.company_id)
  end
  # rubocop:endable Metrics/AbcSize

  def intro; end

  def search_page
    @without_menu = true
    request_url = "/brands"
    @brands = Chelaike::FetchService.get(request_url, tenant_company_id, nil)[:data]
  end

  def short_search
    request_url = "/cars/short_search"
    request_params = {}
    request_params[:query] = params.to_unsafe_h.except("controller", "action")
    @cars = Chelaike::FetchService.get(request_url, tenant_company_id, request_params)
  end

  def condition_search
    request_url = "/cars/search"
    request_params = params.to_unsafe_h.except("controller", "action")
    request_params = request_params.delete_if { |_, value| value.blank? }
    @cars = Chelaike::FetchService.get(request_url, tenant_company_id, request_params)
    render json: @cars[:data].size
  end

  def ids_search
    request_url = "/cars/ids_search"
    request_params = {}
    request_params[:id] = params[:ids]
    Chelaike::FetchService.get(request_url, tenant_company_id, request_params)
  end

  def bargain_cars
    request_params = { query: { is_onsale_eq: true }, page: params[:page], per_page: 20 }
    @onsale_cars = Chelaike::CarService::query(request_params, @tenant.company_id)
  end

  private

  def load_onsale_cars
    request_params = { query: { is_onsale_eq: true }, page: 1, per_page: 6 }
    Chelaike::CarService.query(request_params, @tenant.combination_id)
  end

  def tenant_company_id
    @tenant.company_id
  end

  def alliance_main_site(company_id)
    owner_tenant = Tenant.where(company_id: company_id, tenant_type: "company").first
    owner_tenant.full_url
  end
end
