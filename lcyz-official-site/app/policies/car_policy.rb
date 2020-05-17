# frozen_string_literal: true

class CarPolicy < ApplicationPolicy
  def insurance_detail?(insurance_record)
    return true if tenant.car_configuration&.insurance_price_cents&.zero?
    return unless user
    return true if user.wechat_user.super_manager?
    Order.where(
      open_id: user.open_id,
      orderable: insurance_record,
      status: :success
    ).any?
  end

  def maintenance_detail?(maintenance_record)
    return true if tenant.car_configuration&.maintenance_price_cents&.zero?
    return unless user
    return true if user.wechat_user.super_manager?
    Order.where(
      open_id: user.open_id,
      orderable: maintenance_record,
      status: :success
    ).any?
  end
end
