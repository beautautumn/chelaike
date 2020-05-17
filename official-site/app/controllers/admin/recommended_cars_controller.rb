# frozen_string_literal: true
class Admin::RecommendedCarsController < Admin::ApplicationController
  before_action :find_record, only: [:update, :destroy]

  def index
    @records = @tenant.recommended_cars
    cars = Chelaike::CarService.fetch_by_ids(@records.map(&:car_id), @tenant.company_id)
    @records.each do |record|
      record.car = cars.detect { |car| car.id == record.car_id }
    end
  end

  def new
    param! :per_page, Integer, default: 10
    if @tenant.tenant_type == "solo"
      param! :without_allied, String, default: "true"
    end
    request_params = params.to_unsafe_h.except("controller", "action")
    @result = Chelaike::CarService.query(request_params, @tenant.company_id)
  end

  def create
    return if @tenant.recommended_cars.size >= 10
    @tenant.recommended_cars.create(recommended_car_params)
    redirect_to admin_recommended_cars_path
  end

  def update
    @record.update(recommended_car_params)
    redirect_to admin_recommended_cars_path
  end

  def destroy
    @record.destroy
    redirect_to admin_recommended_cars_path
  end

  private

  def find_record
    @record = @tenant.recommended_cars.find(params[:id])
  end

  def recommended_car_params
    params.require(:recommended_car)
          .permit(:order, :car_id)
  end
end
