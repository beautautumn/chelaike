require "rails_helper"

RSpec.describe V1::AllianceCompaniesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:github) { companies(:github) }

  before do
    give_authority(zhangsan, "联盟管理", "联盟车辆查询")
    login_user(zhangsan)
  end

  describe "GET /api/v1/alliances/:alliance_id/companies" do
    it "获取某个联盟的所有公司" do
      auth_get :index, alliance_id: avengers.id

      expect(response_json[:data].first[:name]).to eq tianche.name
    end
  end

  describe "GET /api/v1/alliances/:alliance_id/companies/no_allied" do
    it "获取某个联盟的所有未加入公司" do
      auth_get :no_allied, alliance_id: avengers.id

      expect(response_json[:data].collect { |e| e["id"] }).not_to include(tianche.id)
    end

    it "搜索某个联盟的所有未加入公司" do
      auth_get :no_allied, alliance_id: avengers.id,
                           query: { name_cont: "同性" }

      expect(response_json[:data].first[:id]).to eq github.id
    end
  end

  describe "GET /api/v1/alliances/:alliance_id/companies/:id" do
    it "获取某个联盟的某个公司" do
      auth_get :show, alliance_id: avengers.id, id: tianche.id

      expect(response_json[:data][:name]).to eq tianche.name
    end
  end
end
