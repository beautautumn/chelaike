require "rails_helper"

RSpec.describe V1::AcquiredCarStatisticsController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
    give_authority(zhangsan, "库存统计查看")

    travel_to Time.zone.parse("2015-01-01")
  end

  describe "GET /api/v1/acquired_car_statistic/acquirers" do
    it "shows info for acquirers" do
      auth_get :acquirers, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/brands" do
    it "shows info for brands" do
      auth_get :brands, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/series" do
    it "shows info for series" do
      auth_get :series, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/ages" do
    it "shows info for ages" do
      auth_get :ages, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/acquisition_prices" do
    it "shows info for acquisition prices" do
      auth_get :acquisition_prices, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/acquisition_types" do
    it "shows info for acquisition types" do
      auth_get :acquisition_types, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/stock_ages" do
    it "shows info for stock ages" do
      auth_get :stock_ages, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/acquired_car_statistic/estimated_gross_profits" do
    it "shows info for estimated gross profits" do
      auth_get :estimated_gross_profits, shop_id: zhangsan.shop_id

      expect(response_json[:data]).to be_present
    end
  end
end
