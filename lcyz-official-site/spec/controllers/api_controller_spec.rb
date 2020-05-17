# frozen_string_literal: true
require "rails_helper"

RSpec.describe ApiController, type: :controller do
  fixtures :all
  let(:orc) { tenants(:orc) }

  describe "GET #company_url" do
    it "returns http success" do
      get :company_url, params: { id: orc.company_id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #all_companies_url" do
    it "returns http success" do
      get :all_companies_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create_tenant" do
    it "returns http success" do
      post :create_tenant, params: {
        api: {
          name: "测试车商",
          company_id: 99999,
          company_type: "solo",
          phone: "13912345678"
        }
      }

      expect(response).to have_http_status(:success)
    end
  end
end
