# frozen_string_literal: true
class CarsController < ApplicationController
  change_view_by_device
  ensure_wechat_login
  skip_before_action :verify_authenticity_token, only: [:like]

  def index
    init_params

    case params[:index_type]
    when "similar_index"
      @patch_load = false
      @show_toolbar = false
      similar_cars(params[:similar_type])
    when "onsale_index"
      @patch_load = false
      @show_toolbar = false
      onsale_cars
    else
      @patch_load = true
      @show_toolbar = true
      index_cars
    end
  end

  def shared_index
    init_params
    param! :per_page, Integer, default: 15

    request_params = params.to_unsafe_h.except("controller", "action")
    request_params = request_params.merge(with_all: true)

    @result = Chelaike::CarService.query(request_params, @tenant.combination_id)
    @seller = current_seller
  end

  def show
    @car = Chelaike::CarService.find(params[:id], @tenant.company_id)
    @detection_report = Chelaike::CarService.detection_report(@car.id, @tenant.combination_id)

    @title = @car.system_name
    @transmission_name = EnumService.find_enum("transmission", @car.transmission).try(:name)

    @similar_cars = Chelaike::CarService.similar({
                                                   car_id: params[:id],
                                                   per_page: 20,
                                                   search_range: "company_only"
                                                 }, @tenant.combination_id).data
    @alliance_similar_cars = Chelaike::CarService.similar({
                                                            car_id: params[:id],
                                                            per_page: 20,
                                                            search_range: "company_except"
                                                          }, @tenant.combination_id).data
    @alliance_main_site = alliance_main_site(@tenant.company_id)
    @alliance_name = alliance_name

    @alliance_similar_count = Chelaike::CarService.similar_count({
                                                                   car_id: params[:id],
                                                                   per_page: 999,
                                                                   search_range: "company_except"
                                                                 }, @tenant.combination_id).to_i
    @seller = current_seller
    @shared = params[:shared_from].present?
    if @current_user.present?
      @maintenance_order = Order.find_by(
        orderable_type: "Maintenance",
        orderable_id: @car.id,
        open_id: @current_user.open_id,
        status: "success"
      )
    end

    # @public_praise_sumup = Chelaike::PublicPraiseService.fetch_sumup(params[:id])
    @public_praise_sumup = nil
    @histories = TransferHistory.where(car_id: params[:id]).order(transfer_at: :asc)

    @maintenance_summary = MaintenanceRecord.find_by(car_id: params[:id])
    @maintenance_price = @tenant.car_configuration&.maintenance_price_cents

    @insurance_record = InsuranceRecord.where(car_id: params[:id]).last
    return if device_detect_helper.mobile?
    car_config = @tenant.car_configuration
    @down_payments = car_config&.down_payments
    @loan_periods =  car_config&.loan_periods
  end

  def insurance_detail
    @car = Chelaike::CarService.find(params[:id], @tenant.combination_id)
    @insurance_record = InsuranceRecord.where(car_id: params[:id]).last

    CarPolicy.new(current_user, current_tenant, @car).insurance_detail?(@insurance_record) ||
      redirect_to(car_path(@car.id, seller_id: current_seller&.id))
  end

  def maintenance_detail
    @car = Chelaike::CarService.find(params[:id], @tenant.combination_id)
    @maintenance_detail = MaintenanceRecord.find_by(car_id: params[:id])

    CarPolicy.new(current_user, current_tenant, @car).maintenance_detail?(@maintenance_detail) ||
      redirect_to(car_path(@car.id, seller_id: current_seller&.id))
  end

  def buy
    @car = Chelaike::CarService.find(params[:id], @tenant.combination_id)
    @title = @car.system_name
    @transmission_name = EnumService.find_enum("transmission", @car.transmission).try(:name)

    @similar_cars = Chelaike::CarService.similar({
                                                   car_id: params[:id],
                                                   per_page: 8,
                                                   search_range: "company_only"
                                                 }, @tenant.combination_id).data

    @alliance_similar_cout = Chelaike::CarService.similar_count({
                                                                  car_id: params[:id],
                                                                  per_page: 999,
                                                                  search_range: "company_except"
                                                                }, @tenant.combination_id)
    @seller = current_seller
    @shared = params[:shared_from].present?
    @order = Order.find_by(
      orderable_type: "Car",
      orderable_id: @car.id,
      open_id: @current_user.open_id,
      status: "success"
    )
  end

  def detail_config
    @car = Chelaike::CarService.find(params[:id], @tenant.combination_id)
  end

  def like
    if @current_user.present?
      @record = FavoriteCar.find_or_initialize_by(
        car_id: params[:id],
        wechat_user_id: @current_user.wechat_user.id,
        tenant_id: @tenant.id
      )
      # 如果存在则取消
      if @record.new_record?
        @record.save!
        render json: { data: { liked: true } }
      else
        @record.destroy!
        render json: { data: { liked: false } }
      end
    else
      render json: { data: { liked: nil } }
    end
  end

  def alliance_similar
    param! :page, Integer, default: 1
    param! :per_page, Integer, default: 24

    @alliance_name = alliance_name
    @result = Chelaike::CarService.similar({
                                             car_id: params[:id],
                                             per_page: params[:per_page],
                                             page: params[:page],
                                             search_range: "company_except"
                                           }, @tenant.combination_id)
  end

  def snippet
    init_params
    param! :per_page, Integer, default: 15

    request_params = params.to_unsafe_h.except("controller", "action")
    @result = Chelaike::CarService.query(request_params, @tenant.combination_id)
    render layout: false
  end

  def brand_and_series
    all_brands = Chelaike::BrandService.fetch_brands(@tenant.combination_id)
    brands = all_brands.map.with_index do |brand, i|
      ret = OpenStruct.new(brand.to_h)
      ret.is_hot = i <= 8
      ret
    end

    all_series = Chelaike::BrandService.fetch_series(nil, @tenant.combination_id, true)
    series = all_series.map.with_index do |serie, i|
      ret = OpenStruct.new(serie.to_h)
      ret.is_hot = i <= 12
      ret
    end

    render json: {
      brands: brands,
      series: series
    }
  end

  def loan_data
    car_config = @tenant.car_configuration

    render json: {
      down_payments: car_config&.down_payments || [],
      loan_periods: car_config&.loan_periods || []
    }
  end

  def public_praises
    fetch_params = {
      per_page: 15,
      page: params[:page],
      car_id: params[:id]
    }
    praises = Chelaike::PublicPraiseService.fetch_public_praises(fetch_params)
    @praises = praises.data
    @praises_count = praises.meta.count
    @car = Chelaike::CarService.find(params[:id], @tenant.combination_id)
  end

  def praises
    fetch_params = {
      page: params[:page],
      car_id: params[:id]
    }
    data = Chelaike::PublicPraiseService.fetch_public_praises(fetch_params)
    render json: data.data
  end

  def inspection_report
    detection = Chelaike::CarService.detection_report(params[:id], @tenant.combination_id).data
    redirect_to detection.url and return unless detection.try(:report_type) == "image"

    @images = detection.images
    render layout: false
  end


  private

  # 得到一般情况下的车辆列表
  def index_cars
    if device_detect_helper.mobile?
      param! :per_page, Integer, default: 15
      all_brands = Chelaike::BrandService.fetch_brands(@tenant.combination_id)
      @hot_brands = all_brands.take(8)
      @group_brands = group_brands(all_brands)
    else
      param! :per_page, Integer, default: 24

      load_desktop_brands
    end

    load_enums
    request_params = params.to_unsafe_h.except("controller", "action")

    current_seller
    @result = Chelaike::CarService.query(request_params, @tenant.combination_id)
  end

  def load_desktop_brands
    all_brands = Chelaike::BrandService.fetch_brands(@tenant.combination_id)
    @hot_brands = fetch_hot_brands(all_brands)
    @group_brands = group_brands(all_brands)
    brand_name = params[:query].try(:[], :brand_name_eq) || ""
    @series = Chelaike::BrandService.fetch_series(brand_name, @tenant.combination_id)
  end

  def onsale_cars
    request_params = params.to_unsafe_h.except("controller", "action")
    request_params = request_params.merge(query: { is_onsale_eq: true }, per_page: 20)

    if request_params["order_field"] == "show_price_cents"
      request_params["order_field"] = "onsale_price_cents"
    end
    @result = Chelaike::CarService.query(request_params, @tenant.combination_id)

    return if device_detect_helper.mobile?
    load_enums
    load_desktop_index
  end

  # 得到相似车辆列表
  def similar_cars(similar_type)
    search_range = {
      "company" => "company_only",
      "alliance" => "company_except"
    }.fetch(similar_type)

    @car = Chelaike::CarService.find(params[:car_id], @tenant.combination_id)
    @title = @car.system_name
    @transmission_name = EnumService.find_enum("transmission", @car.transmission).try(:name)

    @result = Chelaike::CarService.similar({
                                             car_id: params[:car_id],
                                             per_page: 20,
                                             search_range: search_range
                                           }, @tenant.combination_id)

    return if device_detect_helper.mobile?
    load_enums
    load_desktop_brands
  end

  def fetch_hot_brands(all_brands)
    hot_brands = all_brands.take(14)
    current_brand = params[:query].try(:[], :brand_name_eq)
    if current_brand && !hot_brands.detect { |brand| brand.name == current_brand }
      hot_brands.pop
      hot_brands.push(OpenStruct.new(name: current_brand))
    end
    hot_brands
  end

  def init_params
    param! :order_by, String, in: %w(asc desc), default: "desc"
    param! :query, Hash
    param! :page, Integer, default: 1
    param! :without_allied, String, default: "true"
  end

  def load_enums
    @price_enums = EnumService.fetch_enums "price_range"
    @age_enums = EnumService.fetch_enums "age_range"
    @car_type_enums = EnumService.fetch_enums "car_type"
    @mileage_enums = EnumService.fetch_enums "mileage"
    @displacement_enums = EnumService.fetch_enums "displacement"
    @fuel_type_enums = EnumService.fetch_enums "fuel_type"
    @transmission_enums = EnumService.fetch_enums "transmission"
    @color_enums = EnumService.fetch_enums "color"
    @emission_standard_enums = EnumService.fetch_enums "emission_standard"
    @sort_enums = EnumService.fetch_enums "sort"
  end

  def alliance_main_site(company_id)
    owner_tenant = Tenant.where(company_id: company_id, tenant_type: "company").first
    owner_tenant.full_url
  end

  def alliance_name
    return if @tenant.shop
    return @tenant.company&.name
  end

end
