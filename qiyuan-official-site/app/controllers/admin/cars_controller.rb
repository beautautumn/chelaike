# frozen_string_literal: true
class Admin::CarsController < Admin::ApplicationController
  def index
    request_params = params.to_unsafe_h.except("controller", "action")
    request_params[:with_all] = true
    @result = Chelaike::CarService.query(request_params, @tenant.company_id)

    @companies = if @tenant.tenant_type == "alliance"
                   Chelaike::CompanyService.alliance_members(@tenant.company_id)
                 else
                   []
                 end
    @brands = Chelaike::BrandService.fetch_brands(@tenant.combination_id)
  end

  def series
    series = Chelaike::BrandService.fetch_series(params[:brand_name], @tenant.company_id)
    render json: { data: series }
  end

  def sellable
    car_params = {
      id: params[:id],
      car: { sellable: params[:sellable] }
    }
    car = Chelaike::CarService.update(car_params, @tenant.company_id)
    render json: car
  end
end
