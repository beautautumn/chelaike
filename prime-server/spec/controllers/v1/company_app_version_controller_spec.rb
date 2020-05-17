require "rails_helper"

RSpec.describe V1::CompanyAppVersionController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:v100) { app_versions(:v100) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/company/app_version" do
    it "获取当前版本" do
      auth_get :show

      expect(response_json[:data][:version_number]).to eq "1.0.2"
    end
  end

  describe "GET /api/v1/company/app_version" do
    it "获取当前鸿升版本" do
      auth_get :show, version_category: "hongsheng"

      expect(response_json[:data][:version_number]).to eq "1.0.1"
    end
  end
end
