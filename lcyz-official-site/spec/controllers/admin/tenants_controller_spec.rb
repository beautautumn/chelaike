# frozen_string_literal: true
require "rails_helper"

RSpec.describe Admin::TenantsController, type: :controller do
  before do
    login_tenant
  end

  describe "GET #companies" do
    it "gets result" do
      VCR.use_cassette "chelaike/company/all_by_condition" do
        get :companies, params: { name: "杭州天车" }
        expect(response.status).to eq(200)
      end
    end
  end

  describe "GET #alliances" do
    it "gets result" do
      VCR.use_cassette "chelaike/alliance/all_by_condition" do
        get :alliances, params: { name: "啦" }
        expect(response.status).to eq(200)
      end
    end
  end

  describe "PUT #tenant" do
    it "gets result" do
      patch :update, params: { tenant: { name: "test" } }
      expect(response).to redirect_to(admin_tenant_path)
    end
  end
end
