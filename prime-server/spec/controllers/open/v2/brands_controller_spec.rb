require "rails_helper"

RSpec.describe Open::V2::BrandsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/brands" do
    it "获取所有品牌" do
      VCR.use_cassette("open_brands") do
        open_get :index
      end

      expect(response_json[:data]).to be_present
    end

    it "动态获取" do
      open_get :index, relative: true

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/open/v2/series?brand[name]=奥迪" do
    it "获取奥迪的所有车系" do
      VCR.use_cassette("open_series") do
        open_get :series, brand: { name: "奥迪" }
      end

      expect(response_json[:data]).to be_present
    end

    it "动态获取" do
      open_get :series, relative: true

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/open/v2/styles?series[name]=奥迪A3&" do
    it "获取奥迪A3的所有车款" do
      VCR.use_cassette("open_styles") do
        open_get :styles, series: { name: "奥迪A3" }
      end

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/open/v2/style" do
    it "获取奥迪A3的某车款详细信息" do
      VCR.use_cassette("open_style") do
        open_get :style, series: { name: "奥迪A3" },
                         style: {
                           name: "2014款 Sportback 35 TFSI 自动豪华型"
                         },
                         region: {
                           province: "福建省",
                           city: "莆田市"
                         }
      end

      expect(response_json[:data]).to be_present
      expect(response_json[:data][:price][:minimum_price]).to eq 286_700
    end
  end
end
