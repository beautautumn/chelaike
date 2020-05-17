require "rails_helper"

RSpec.describe Che3bao::CarsController do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:aodi) { cars(:aodi) }

  describe "GET /api/stock/list" do
    it "查询车辆列表" do
      get :index, accessToken: tianche.md5_name

      expect(response_json[:rows].first[:stockId]).to be_present
      expect(response_json[:meta][:total]).to be_present
    end

    it "查询多家公司的车辆列表" do
      get :index, accessToken: tianche.md5_name, company_ids: warner.id

      expect(response_json[:rows].first[:stockId]).to be_present
      expect(response_json[:meta][:total]).to be_present
    end

    it "按条件查询" do
      search_params = {
        brandName: "奥迪",
        seriesName: "A3",
        catalogueName: "奥迪",
        priceLow: 10,
        priceHigh: 30,
        carAgeLow: 0,
        carAgeHigh: 5,
        mileageLow: 200,
        mileageHigh: 400,
        instockDateLow: "2015-01-01",
        instockDateHigh: "2015-01-15",
        updated_at_gteq: "2015-01-01",
        ovLow: 1.3,
        ovHigh: 1.8,
        stockState: 1,
        showNoPrice: 1,
        carType: 5,
        pageNum: 1,
        pageSize: 1,
        showHasPic: 0,
        sortBy: "price_high",
        accessToken: tianche.md5_name
      }

      get :index, search_params

      expect(response_json[:rows].first[:brandName]).to eq "奥迪"
    end

    it "查询某辆车的详情" do
      get :show, accessToken: tianche.md5_name, stockId: aodi.id

      expect(response_json[:stockDetail][:dimCodeUrl]).to be_present
    end

    it "查询多家公司中的某辆车的详情" do
      get :show, accessToken: tianche.md5_name, stockId: aodi.id, company_ids: warner.id

      expect(response_json[:stockDetail][:dimCodeUrl]).to be_present
    end
  end
end
