require "rails_helper"

RSpec.describe V1::AppVersionsController do
  fixtures :all

  let(:v100) { app_versions(:v100) }

  describe "GET /api/v1/app_versions/:id" do
    it "获取指定版本" do
      get :show, id: v100.id

      expect(response_json[:data][:version_number]).to eq "1.0.0"
    end
  end

  describe "GET /api/v1/app_versions/production" do
    it "获取当前正式版本" do
      get :production

      expect(response_json[:data][:version_number]).to eq "1.0.0"
    end
  end
end
