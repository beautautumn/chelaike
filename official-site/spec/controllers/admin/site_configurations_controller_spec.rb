# frozen_string_literal: true
require "rails_helper"

RSpec.describe Admin::SiteConfigurationsController, type: :controller do
  before do
    login_tenant
  end

  describe "PATCH #site_configuration" do
    it "gets result" do
      patch :update, params: { site_configuration: { tiitle: "test" } }
      expect(response).to redirect_to(admin_tenant_path)
    end
  end
end
