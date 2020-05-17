require "rails_helper"

RSpec.describe V1::AllianceDashboard::CompaniesController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:chuche_alliance) { alliances(:chuche) }
  let(:tianche) { companies(:tianche) }

  before do
    give_authority(alliance_zhangsan, "员工管理")
    login_user(alliance_zhangsan)
  end

  before do
    chuche_alliance.add_companies([tianche])
    chuche_alliance.update(alliance_company: alliance_tianche)
  end

  describe "GET companies" do
    it "得到这个联盟里的所有子车商列表" do
      auth_get :index
      expect(response_json[:data].count).to eq 1
    end
  end

  describe "PUT update" do
    it "更新子车商在联盟里的信息" do
      alliance_tianche.add_company(tianche)

      company_params = {
        nickname: "牛逼", contact: "新的联系人",
        contact_mobile: "12344321",
        street: "好的地方"
      }

      auth_put :update, id: tianche.id, company: company_params

      relationship = AllianceCompanyRelationship.where(
        company_id: tianche.id,
        alliance_id: chuche_alliance.id).first

      expect(relationship.street).to eq "好的地方"
      expect(tianche.reload.nickname).to eq "牛逼"
    end
  end
end
