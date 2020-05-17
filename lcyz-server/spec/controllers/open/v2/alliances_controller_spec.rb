require "rails_helper"

RSpec.describe Open::V2::AlliancesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:chuche) { alliances(:chuche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/alliances" do
    it "获取联盟信息" do
      open_get :index
      expect(response_json[:data].size).to be > 0
    end
  end

  describe "GET /api/open/v2/alliances" do
    it "获取联盟信息" do
      open_get :show, id: chuche.id
      expect(response_json[:data].size).to be > 0
    end
  end
end
