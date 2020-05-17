# frozen_string_literal: true
require "rails_helper"

RSpec.describe Admin::RecommendedCarsController, type: :controller do
  fixtures :all
  before do
    login_tenant
    @request.host = "forthehorde.com:3000"
  end

  describe "GET #index" do
    let(:current_tenant) { tenants(:orc) }
    it "gets cars" do
      VCR.use_cassette "chelaike/recommended_cars/index" do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

  describe "POST #create" do
    let(:current_tenant) { tenants(:orc) }
    let(:porsche) { recommended_cars(:porsche) }

    it "gets cars" do
      VCR.use_cassette "chelaike/recommended_cars/create" do
        post :create, params: { car_id: 321 }, format: "js"
        expect(response.status).to eq(200)
      end
    end

    it "add recommended car" do
      VCR.use_cassette "chelaike/recommended_cars/create" do
        before_count = current_tenant.recommended_cars.size
        post :create, params: { car_id: 321 }, format: "js"
        after_count = current_tenant.recommended_cars.reload.size
        expect(after_count).to eq(before_count + 1)
      end
    end

    it "remove recommended car" do
      VCR.use_cassette "chelaike/recommended_cars/destroy" do
        porsche.update_attributes(tenant: current_tenant)
        before_count = current_tenant.recommended_cars.reload.size

        post :destroy, params: { id: 1 }, format: "js"
        after_count = current_tenant.recommended_cars.reload.size

        expect(before_count).to eq(after_count + 1)
      end
    end
  end
end
