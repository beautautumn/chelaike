require "rails_helper"

RSpec.describe V1::CarStatisticsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    give_authority(zhangsan, "库存统计查看")
    travel_to(Time.zone.parse("2015-01-01"))
    login_user(zhangsan)
  end

  describe "GET /api/v1/car_statistic/overview" do
    it "shows info of cars" do
      auth_get :overview

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/statistic?type=cars_acquired" do
    it "shows info for specify type" do
      travel_to Time.zone.parse("2015-01-01")
      auth_get :show, type: "cars_acquired"

      expect(response_json[:data]).to be_present
    end
  end
end
