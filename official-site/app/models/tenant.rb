# frozen_string_literal: true
# == Schema Information
#
# Table name: tenants # 平台租户，对应每个商家
#
#  id                    :integer          not null, primary key
#  name                  :string                                 # 商家名
#  subdomain             :string                                 # 二级子域名
#  tld                   :string                                 # 顶级域名
#  app_secret            :string                                 # 对应车来客里的app_secret
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer                                # 对应车来客公司
#  tenant_type           :string                                 # 租户类型： 商家、联盟
#  phone                 :string                                 # 租户的手机，登录用
#  default_wechat_app_id :integer                                # 默认微信公众号 ID
#

# subdomain: 子域名，如 chuche.site.chelaike.com 中的 'chuche'
# tld      : 顶级域名，如 www.91chuche.com
# 在各个环境的配置文件(如 config/environments/staging.rb)中修改
# config.action_dispatch.tld_length = 2 来限制匹配域名的长度
# app_secret: 预留字段，用于加密区分公司身份。目前直接用token加密

# 微信订阅号和未通过认证的服务号没有 snsapi 权限, 不能获取用户信息, 需要绑定到默认的
# 车来客公众号.

class Tenant < ApplicationRecord
  extend Enumerize
  extend EnumerizeWithGroups

  has_many :users
  has_many :recommended_cars
  has_many :advertisements
  has_one :site_configuration
  has_one :car_configuration
  has_one :wechat_app
  belongs_to :default_wechat_app, class_name: "WechatApp"

  enumerize :tenant_type, in: %i(solo alliance)
  attr_accessor :company, :host

  # 有默认公众号的优先返回默认公众号
  def app
    default_wechat_app || wechat_app
  end

  def full_url
    subdomain_url = case Rails.env
                    when "production"
                      "site.chelaike.com"
                    else
                      "lina-site.chelaike.com"
                    end
    tld.presence || "#{subdomain}.#{subdomain_url}"
  end
end
