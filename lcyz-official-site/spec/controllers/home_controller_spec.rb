# frozen_string_literal: true
require "rails_helper"

RSpec.describe HomeController, type: :controller do
  fixtures :all
  let(:orc) { tenants(:orc) }
  let(:human) { tenants(:human) }

  describe "GET #index" do
    it "use mobile layout" do
      mock_mobile
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template("layouts/mobile")
    end

    it "use desktop layout" do
      mock_descktop
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template("layouts/desktop")
    end
  end

  describe "finds tenant" do
    it "finds tenant by Top Level Domain" do
      request.host = "www.forthehorde.com"
      get :index
      expect(assigns(:tenant)).to eq orc
    end
    it "finds tenant by subdomain" do
      request.host = "human.example.com"
      get :index
      expect(assigns(:tenant)).to eq human
    end
  end

  describe "GET #search_page" do
    it "render page" do
      request.host = "forthehorde.com"
      VCR.use_cassette "home/search_page" do
        get :search_page
        expect(response.status).to eq(200)
      end
    end

    it "get brands info" do
      request.host = "forthehorde.com"
      VCR.use_cassette "home/search_page" do
        get :search_page
        expect(response.status).to eq(200)
      end
    end
  end
end
