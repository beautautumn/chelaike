require "rails_helper"

RSpec.describe Open::V2::CompaniesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/companies" do
    it "获取公司列表" do
      open_get :index
      expect(response_json[:data].size).to be > 0
    end
  end

  describe "GET alliance_owner_company" do
    it "得到这个商家所在联盟的主站商家" do
      company = tianche
      open_get :alliance_owner_company, company_id: company
      data = response_json[:data]
      expect(data[:owner_id]).to eq tianche.id
      expect(data[:alliance_name]).to eq "复仇者联盟"
    end
  end

  describe "GET alliance_members" do
    it "取得联盟下属所有参与公司" do
      company = tianche
      open_get :alliance_members, company_id: company
      expect(response_json[:data].length).to eq 0
    end
  end

  describe "GET shops" do
    it "得到公司里所有分店信息" do
      company = tianche
      open_get :shops, company_id: company
      expect(response_json[:data]).to be_present
    end
  end
end
