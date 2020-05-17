# frozen_string_literal: true
class ApiController < ActionController::Base
  def company_url
    tenant = Tenant.find_by(company_id: params[:id])
    return_data = { tld: tenant.try(:tld), subdomain: tenant.try(:subdomain) }
    render json: { data: return_data }
  end

  def all_companies_url
    return_arr = Tenant.all.map do |tenant|
      {
        company_id: tenant.company_id,
        tld: tenant.tld,
        subdomain: tenant.subdomain
      }
    end
    render json: { data: return_arr }
  end

  # 创建新车商时开通官网的接口
  def create_tenant
    # app = WechatApp.find_by(nick_name: "车来客")
    app = WechatApp.first

    subdomain = if company_params[:shop_id].present?
                  "#{company_params[:company_id]}_#{company_params[:shop_id]}"
                else
                  company_params[:company_id].to_s
                end
    @tenant = Tenant.create!(
      company_id: company_params[:company_id],
      shop_id: company_params[:shop_id],
      tenant_type: company_params[:company_type],
      phone: company_params[:phone],
      name: company_params[:name],
      subdomain: subdomain,
      default_wechat_app_id: app.id
    )
    render json: { data: @tenant }
  end

  private

  def company_params
    params.require(:api).permit(:name, :company_id, :shop_id, :company_type, :phone)
  end

  # 拼音首字母, 备用
  def initials(name)
    Pinyin.t(name).split.map(&:chr).join
  end
end
