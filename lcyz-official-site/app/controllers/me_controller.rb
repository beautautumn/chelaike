# frozen_string_literal: true
class MeController < ApplicationController
  change_view_by_device
  ensure_wechat_login

  def index; end

  def enquiries
    return unless @current_user
    if device_detect_helper.mobile?
      ids = @current_user&.enquiries&.where(tenant_id: @tenant.id)&.pluck(:car_id)
    else
      cars = @current_user&.enquiries&.where(tenant_id: @tenant.id)
      return [] unless cars
      @total = cars.count
      ids = cars.page(params[:page]).per(30).pluck(:car_id)
    end

    @cars = Chelaike::CarService.fetch_by_ids(ids, @tenant.company_id)
  end

  def favorites
    return unless @current_user
    if device_detect_helper.mobile?
      ids = @current_user&.favorite_cars&.where(tenant_id: @tenant.id)&.pluck(:car_id)
    else
      cars = @current_user&.favorite_cars&.where(tenant_id: @tenant.id)
      return [] unless cars
      @total = cars.count
      ids = cars.page(params[:page]).per(30).pluck(:car_id)
    end
    @cars = Chelaike::CarService.fetch_by_ids(ids, @tenant.company_id)
  end
end
