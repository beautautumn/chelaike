require "rails_helper"

RSpec.describe V1::StatisticsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/statistics/company" do
    it "show all statistics" do
      auth_get :company

      expect(response_json).to be_present
    end
  end

  describe "GET /api/v1/statistics?type=cars_sold_today" do
    it "show all cars acquired this month" do
      auth_get :show

      expect(response_json).to be_present
    end
  end
end
