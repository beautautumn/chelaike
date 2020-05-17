require "rails_helper"

RSpec.describe V1::DailyManagementsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
    give_authority(zhangsan, "求购客户跟进", "求购客户管理", "出售客户管理", "出售客户跟进")
  end

  describe "GET /api/v1/daily_management" do
    it "show daily management info" do
      auth_get :show

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/daily_management/unread" do
    it "show unread" do
      auth_get :unread

      expect(response_json[:data][:unread]).to be_truthy
    end
  end
end
