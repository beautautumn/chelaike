require "rails_helper"

RSpec.describe Open::V2::PublicPraisesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/public_praises" do
    it "获取车辆口碑列表" do
      VCR.use_cassette("public_praises_index") do
        open_get :index, car_id: aodi.id, per_page: 4
        expect(response_json.size).to be > 0
      end
    end

    it "获取车辆口碑概要" do
      VCR.use_cassette("public_praises_sumup") do
        open_get :sumup, car_id: aodi.id
        expect(response_json[:data].size).to be > 0
      end
    end
  end
end
