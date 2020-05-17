# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include TenantFilter
  include SellerFilter
  include UserAgentConcern
  include WechatFilter
  include Pundit

  protect_from_forgery with: :exception

  rescue_from(Wechat::Component::TicketError) do |_err|
    render text: "微信第三方平台 component_verify_ticket 缓存读取失败，请检查配置是否正确或者是否开启缓存", status: 404 # forbidden
  end

  rescue_from(Wechat::Component::IPWhitelistError) do |_err|
    render text: "微信第三方平台没有设置 IP 白名单", status: 404 # forbidden
  end

  def basic_params_validations
    param! :order_by, String, in: %w(asc desc), default: "desc"
    param! :query, Hash
    param! :page, Integer, default: 1
    param! :per_page, Integer, default: 15
  end

  def contact_phone
    seller = current_seller
    return seller[:phone] if seller
    return @tenant.shop.phone if @tenant && @tenant.shop
    return @tenant.company.contact_mobile if  @tenant && @tenant.company
  end

  def favorite_car?(car)
    @current_user&.favorite_cars&.pluck(:car_id)&.include?(car&.id)
  end

  def recommended_car?(car)
    @tenant&.recommended_cars&.pluck(:car_id)&.include?(car&.id)
  end

  def bargin_car?(car)
    car.is_onsale
  end

  def in_stock_car?(car)
    %w(in_hall preparing shipping loaning transferred online_show).include?(car.state)
  end

  def group_brands(brands)
    result = {}
    # brands.each {|brand| result[brand.first_letter].push(brand) }
    brands.each do |b|
      result[b.first_letter] = [] unless result.key?(b.first_letter)
      result[b.first_letter].push(b)
    end
    result.to_a.sort { |a, b| a[0] <=> b[0] }
  end

  def down_payment(price)
    down_payment_rate = @tenant.car_configuration.try(:default_loan)
    return "-" if !price || !down_payment_rate
    (price * down_payment_rate / 100.0).round(2).to_s
  end

  helper_method :contact_phone, :favorite_car?, :recommended_car?,
                :bargin_car?, :down_payment, :in_stock_car?
end
