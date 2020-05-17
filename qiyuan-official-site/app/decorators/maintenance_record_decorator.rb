# frozen_string_literal: true
class MaintenanceRecordDecorator < ApplicationDecorator
  delegate_all

  def pay_link(car, user = nil)
    user ||= h.current_user
    maintenance_price = h.current_tenant.car_configuration&.maintenance_price_cents
    hint = maintenance_price.zero? ? "免费" : "已付费"
    if CarPolicy.new(user, h.current_tenant, car).maintenance_detail?(object)
      h.link_to(
        "查看完整报告（#{hint}）",
        h.maintenance_detail_car_path(car.id),
        class: "weui_btn weui_btn_plain_default buy-button"
      )
    else
      data_token = Wechat::DesktopAuth.encode "tenant_id=#{h.current_tenant.id};orderable_id=#{object.id};orderable_type=MaintenanceRecord;open_id=#{user&.open_id};price=#{maintenance_price}"
      h.link_to(
        "查看完整记录 （#{maintenance_price / 100}元/次）",
        "http://#{domain}/pay/index?tenant_id=#{h.current_tenant.id}&token=#{data_token}&car=#{car.id}",
        class: "weui_btn weui_btn_plain_default buy-button"
      )
    end
  end
end
