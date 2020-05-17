# frozen_string_literal: true
module CarsHelper
  def date_format(date_string)
    return " - " unless date_string.present?
    date_string.gsub(/-[^-]+$/, "")
  end

  def price_format(price_string)
    price_string.present? ? price_string : " - "
  end

  def mileage_format(mileage_string)
    mileage_string.present? ? mileage_string : " - "
  end

  def year_month_ch(date_string)
    return " - " unless date_string.present?
    Time.zone.parse(date_string).strftime("%Y年%m月")
  end

  def date_simple(date_string)
    return " - " unless date_string.present?
    Time.zone.parse(date_string).strftime("%Y-%m-%d")
  end

  def car_cover(url, scale_str = nil)
    url ? img_scale(url, scale_str) : asset_path("common/car.png")
  end

  def img_scale(url, scale_str)
    return url unless scale_str
    scale_atrr = scale_str.split("x")
    if url.include?("image.che3bao.com")
      return "#{url}?imageView/1/w/#{scale_atrr[0]}/h/#{scale_atrr[1]}"
    end
    "#{url}?x-oss-process=image/resize,m_fill,w_#{scale_atrr[0]},h_#{scale_atrr[1]},limit_0"
  end

  def licensed_info(car)
    case car.license_info
    when "unlicensed"
      ["-", "未上牌"]
    when "new_car"
      ["-", "新车"]
    when "licensed"
      return ["-", "-"] unless car.licensed_at.present?
      diff = TimeDifference.between(Time.zone.parse(car.licensed_at), Time.zone.now)
                           .in_general
      ["#{diff[:years]}年#{diff[:months]}个月", "#{year_month_ch(car.licensed_at)}上牌"]
    else
      ["-", "-"]
    end
  end

  # 详情页里电话联系的电话号码
  def detail_contact_phone
    if @seller
      @seller.phone
    else
      company = @tenant.company
      company.sale_mobile.presence || company.contact_mobile
    end
  end

  def favorite_image(car)
    favorite_car?(car) ? asset_path("common/favorite_yes.png") : asset_path("common/favorite.png")
  end

  def car_detail_pay_report_link(car, tenant, user, report_object)
    report_type = report_object.class.name

    # 支付链接参数
    price = current_tenant.car_configuration.try("#{report_type.split("Record")[0].downcase}_price_cents".to_sym) || 1500
    token = Wechat::DesktopAuth.encode "tenant_id=#{tenant.id};orderable_id=#{report_object.id};orderable_type=#{report_type};open_id=#{user&.open_id};price=#{price}"
    pay_url = user.present? ? car_pay_index_path(car.id, token: token) : new_wechat_path
    report_url = report_type == "MaintenanceRecord" ? maintenance_detail_car_url(car.id) : insurance_detail_car_url(car.id)
    link_method = user.present? ? "POST" : "GET" # 设置登录、非登录链接的请求方法

    pay_url = report_url  if price == 0
    link_method = "GET"  if price == 0

    ordered = Order.where(tenant_id: tenant.id, open_id: user&.open_id, orderable_id: report_object.id, orderable_type: report_object.class.name, status: "success").first

    if ordered || price == 0
      link_to(
        price == 0 ? "查看完整记录 （0元/次）" : "扫码查看完整报告（已付费）",
        "javascript:void(0)",
        class: "buy-button bought-button",
        id: "report_paid_#{report_type.downcase}",
        data: { qr_url: report_url }
      )
    else
      link_to(
        "查看完整记录 （#{price / 100}元/次）",
        pay_url,
        class: "buy-button",
        id: "see-full-evaluate-report",
        remote: true,
        method: link_method
      )
    end
  end

  # 官网检测报告 url helper
  def inspection_report_link car, inspection_report, browser = 'desktop'
    case inspection_report.data.try(:report_type)
    when "image"
      link_to inspection_report_car_url(car.id), target: '_blank', class: 'more-button' do
        browser == "mobile" ? content_tag(:i, "查看检测报告", :class => "fa fa-angle-right") : "查看检测报告"
      end
    else
      link_to inspection_report.try(:data).try(:url), target: '_blank', class: 'more-button' do
        browser == "mobile" ? content_tag(:i, "查看检测报告", :class => "fa fa-angle-right") : "查看检测报告"
      end
    end
  end

  def status_with_color(result)
    if result == "异常" || result == "有"
      content_tag :span, class: "item-value error" do
        result
      end
    else
      content_tag :span, class: "item-value" do
        result
      end
    end
  end
end
