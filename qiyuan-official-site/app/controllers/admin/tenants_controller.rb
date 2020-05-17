# frozen_string_literal: true
class Admin::TenantsController < Admin::ApplicationController
  # rubocop:disable Metrics/CyclomaticComplexity
  def show
    @tenant.company_id = params[:company_id] || @tenant.company_id
    if params[:tenant_type] &&
       params[:tenant_type] != @tenant.tenant_type &&
       !params[:company_id]
      @tenant.company_id = nil
    end
    @tenant.tenant_type = params[:tenant_type] || @tenant.tenant_type || "solo"
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def update
    @tenant.update_attributes(tenant_params)
    redirect_to admin_tenant_path, status: 303, notice: "保存成功"
  end

  def companies
    basic_params_validations
    query_params = {
      query: {
        name_cont: params[:name],
        province_cont: params[:province],
        city_cont: params[:city]
      },
      page: params[:page],
      per_page: params[:per_page]
    }

    data = Chelaike::FetchService.get("/companies", nil, query_params)
    @companies = data[:data]
  end

  def company
    redirect_to admin_tenant_path(company_id: params[:id], tenant_type: "solo")
  end

  def alliances
    basic_params_validations
    query_params = {
      query: {
        name_cont: params[:name],
        owner_name_cont: params[:company_name]
      },
      page: params[:page],
      per_page: params[:per_page]
    }

    data = Chelaike::FetchService.get("/alliances", nil, query_params)
    @alliances = data[:data]
  end

  def alliance
    redirect_to admin_tenant_path(company_id: params[:id], tenant_type: "alliance")
  end

  private

  def tenant_params
    params.require(:tenant)
          .permit(:name, :subdomain, :tld, :tenant_type, :company_id)
  end
end
