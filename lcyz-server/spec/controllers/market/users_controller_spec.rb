require "rails_helper"

RSpec.describe Market::UsersController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/market/users/info" do
    it "returns user's info" do
      request.headers["AutobotsToken"] = current_user.simple_token
      get :info, phone: zhangsan.phone
      expect(response_json).to be_present
    end
  end
end
