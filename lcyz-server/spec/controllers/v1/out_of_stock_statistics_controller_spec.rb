require "rails_helper"

RSpec.describe V1::OutOfStockStatisticsController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
    give_authority(zhangsan, "库存统计查看")

    travel_to Time.zone.parse("2015-01-20")
  end

  describe "GET /api/v1/out_of_stock_statistic/stock_ages" do
    it "shows info by stock ages" do
      auth_get :stock_ages

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/stock_out_modes" do
    it "shows info by acquisition types" do
      auth_get :stock_out_modes

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/closing_costs" do
    it "shows info by closing costs" do
      auth_get :closing_costs

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/ages" do
    it "shows info by ages" do
      auth_get :ages

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/brands" do
    it "shows info by brands" do
      auth_get :brands

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/series" do
    it "shows info by series" do
      auth_get :series

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/appraisers" do
    it "shows info by appraisers" do
      auth_get :appraisers

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/out_of_stock_statistic/sellers" do
    it "shows info by sellers" do
      auth_get :sellers

      expect(response_json[:data]).to be_present
    end
  end
end
