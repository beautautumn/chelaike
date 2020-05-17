require "rails_helper"

RSpec.describe Open::V1::SaleIntentionsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v1/sale_intentions/new" do
    it "添加我要卖车" do
      expect do
        open_get :new, sale_intention: {
          brand_name: "奥迪",
          series_name: "奥迪A3",
          style_name: "2014款 Sportback 35 TFSI 自动豪华型",
          mileage: 23,
          licensed_at: Time.zone.now,
          phone: "18668237883",
          province: "浙江",
          city: "杭州",
          expected_price_wan: 20
        }
      end.to change { Intention.count }.by(1)
    end
  end
end
