require "rails_helper"

RSpec.describe EasyLoan::RegionsController, type: :controller do
  fixtures :all

  let(:beijing) { provinces(:beijing) }

  describe "GET provinces" do
    it "获取省份数据" do
      get :provinces

      expect(response_json[:data].first[:short_name]).to eq "北京"
    end
  end

  describe "GET cities" do
    it "获取市数据" do
      get :cities, province: { name: beijing.name }

      expect(response_json[:data].first[:short_name]).to eq "北京"
    end
  end
end
