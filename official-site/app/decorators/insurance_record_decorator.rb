# frozen_string_literal: true
class InsuranceRecordDecorator < ApplicationDecorator
  delegate_all

  def pay_link(car, user = nil)
    user ||= h.current_user
    insurance_price = h.current_tenant.car_configuration&.insurance_price_cents
    hint = insurance_price.zero? ? "免费" : "已付费"
    if CarPolicy.new(user, h.current_tenant, car).insurance_detail?(object)
      h.link_to(
        "查看完整报告（#{hint}）",
        h.insurance_detail_car_path(car.id),
        class: "weui_btn weui_btn_plain_default buy-button"
      )
    else
      data_token = Wechat::DesktopAuth.encode "tenant_id=#{h.current_tenant.id};orderable_id=#{object.id};orderable_type=InsuranceRecord;open_id=#{user&.open_id};price=#{insurance_price}"
      h.link_to(
        "查看完整记录 （#{insurance_price / 100}元/次）",
        "http://#{domain}/pay/index?tenant_id=#{h.current_tenant.id}&token=#{data_token}&car=#{car.id}",
        class: "weui_btn weui_btn_plain_default buy-button"
      )
    end
  end
end
