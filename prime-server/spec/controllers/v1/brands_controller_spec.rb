require "rails_helper"

RSpec.describe V1::BrandsController do
  fixtures :all

  describe "GET /api/v1/brands" do
    it "获取所有品牌" do
      VCR.use_cassette("brands") do
        get :index
      end

      expect(response_json[:data]).not_to be_empty
    end
  end

  describe "GET /api/v1/series?brand[name]=奥迪" do
    it "获取奥迪的所有车系" do
      VCR.use_cassette("series") do
        get :series, brand: { name: "奥迪" }
      end

      expect(response_json[:data]).not_to be_empty
    end
  end

  describe "GET /api/v1/styles?series[name]=奥迪A3&" do
    it "获取奥迪A3的所有车款" do
      VCR.use_cassette("styles") do
        get :styles, series: { name: "奥迪A3" }
      end

      expect(response_json[:data]).not_to be_empty
    end
  end

  describe "GET /api/v1/style" do
    it "获取奥迪A3的某车款详细信息" do
      VCR.use_cassette("style") do
        get :style, series: { name: "奥迪A3" },
                    style: {
                      name: "2014款 Sportback 35 TFSI 自动豪华型"
                    },
                    region: {
                      province: "福建省",
                      city: "莆田市"
                    }
      end

      expect(response_json[:data]).not_to be_empty
      expect(response_json[:data][:price][:minimum_price]).to eq 286_700
    end

    it "获取车款信息并不传地区信息" do
      VCR.use_cassette("style_without_region") do
        get :style, series: { name: "奥迪A3" },
                    style: {
                      name: "2014款 Sportback 35 TFSI 自动豪华型"
                    }
      end

      expect(response_json[:data]).not_to be_empty
    end
  end

  describe "GET easy_config" do
    it "得到快速配置的选项内容" do
      get :easy_config
      expect(response_json[:data]).to be_present
    end
  end
end
