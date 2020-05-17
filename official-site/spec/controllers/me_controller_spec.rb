# frozen_string_literal: true
require "rails_helper"

RSpec.describe MeController, type: :controller do
  fixtures :all
  before(:each) do
    mock_mobile
  end

  describe "GET #index" do
    it "returns http success" do
      VCR.use_cassette "chelaike/me/index" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #enquiries" do
    it "returns http success" do
      VCR.use_cassette "chelaike/me/enquiries" do
        get :enquiries
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #favorites" do
    it "returns http success" do
      VCR.use_cassette "chelaike/me/favorites" do
        get :favorites
        expect(response).to have_http_status(:success)
      end
    end
  end
end
