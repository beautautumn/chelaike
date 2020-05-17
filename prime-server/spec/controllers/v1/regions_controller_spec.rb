require "rails_helper"

RSpec.describe V1::RegionsController do
  fixtures :all

  let(:beijing) { provinces(:beijing) }
  let(:beijing_city) { cities(:beijing) }

  describe "GET /api/v1/regions/provinces" do
    it "获取省份数据" do
      get :provinces

      expect(response_json[:data].first[:short_name]).to eq "北京"
    end
  end

  describe "GET /api/v1/regions/cities" do
    it "获取市数据" do
      get :cities, province: { name: beijing.name }

      expect(response_json[:data].first[:short_name]).to eq "北京"
    end
  end

  describe "GET /api/v1/regions/districts" do
    it "获取区数据" do
      get :districts, city: { name: beijing_city.name }

      expect(response_json[:data].first[:name]).to eq "东城区"
    end
  end
end
