require "rails_helper"

RSpec.describe Market::CarsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/market/cars" do
    it "returns cars" do
      request.headers["AutobotsToken"] = current_user.simple_token
      get :index, {
        conditions: {
          updated_at_gteq: aodi.updated_at,
          updated_at_lteq: aodi.updated_at + 5.minutes
        }
      }, "AutobotsToken" => current_user.simple_token

      expect(response_json[:data].size).to be > 0
    end
  end
end
