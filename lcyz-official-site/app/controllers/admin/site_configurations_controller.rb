# frozen_string_literal: true
class Admin::SiteConfigurationsController < Admin::ApplicationController
  def show
    @site_configuration = if @tenant.site_configuration.present?
                            @tenant.site_configuration
                          else
                            SiteConfiguration.new
                          end
  end

  def update
    @site_configuration = if @tenant.site_configuration.present?
                            @tenant.site_configuration
                          else
                            @tenant.create_site_configuration
                          end
    @site_configuration.update_attributes(site_configuration_params)

    redirect_to admin_tenant_path
  end

  private

  def site_configuration_params
    params.require(:site_configuration)
          .permit(:title, :keyword, :description, :icp, :icon, :logo, :slogan, :statistics_code)
  end
end
