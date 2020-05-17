# frozen_string_literal: true
# 根据域名判断租户/公司
# 1. 顶级域名(TLD)搜索
# 2. 二级域名搜索
module TenantFilter
  extend ActiveSupport::Concern
  included do
    helper_method :current_tenant
    before_action :current_tenant
  end

  def current_tenant
    if Rails.env.development? && ENV["WECHAT_DEBUG"].blank?
      @tenant = Tenant.first
    else
      @tenant = Tenant.find_by tld: request.domain
      @tenant = Tenant.find_by subdomain: request.subdomain unless @tenant.present?
      @tenant = Tenant.find_by tld: "www.91chuche.com" if request.domain == "91chuche.com"
      # 找不到租户, 跳转到出错页面
      return redirect_to invalid_path unless @tenant.present?
    end
    @tenant.host = request.base_url
    @app = @tenant.app # 优先返回默认 app
    @tenant&.company = Chelaike::CompanyService.fetch_company_info(@tenant.company_id)
    @tenant
  end

  def valid_tenant?
    current_tenant.present?
  end
end
