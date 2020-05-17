# frozen_string_literal: true
require "rails_helper"

RSpec.describe ContactController, type: :controller do
  describe "GET #index" do
    it "mobile returns http success" do
      VCR.use_cassette "chelaike/company/human" do
        mock_mobile
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    it "desktop returns http success" do
      VCR.use_cassette "chelaike/company/human" do
        mock_descktop
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
