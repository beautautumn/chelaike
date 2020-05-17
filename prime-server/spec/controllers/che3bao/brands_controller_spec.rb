require "rails_helper"

RSpec.describe Che3bao::BrandsController do
  fixtures :all
  let(:tianche) { companies(:tianche) }

  describe "GET /api/param/brandlist" do
    it "查询品牌列表" do
      VCR.use_cassette("che3bao_brands") do
        get :brands, accessToken: tianche.md5_name
      end

      expect(response_json[:data].first[:brandPinYin]).to be_present
    end

    it "查询车系列表" do
      VCR.use_cassette("che3bao_series") do
        get :series, parentCode: "奥迪", accessToken: tianche.md5_name
      end

      expect(response_json[:data].first[:seriesName]).to be_present
    end

    it "查询车款列表" do
      VCR.use_cassette("che3bao_styles") do
        get :styles, parentCode: "奥迪A3", accessToken: tianche.md5_name
      end

      expect(response_json[:data].first[:modelName]).to be_present
    end
  end
end
