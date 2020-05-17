require "rails_helper"

RSpec.describe V1::AllianceCompanyRelationshipsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:github) { companies(:github) }

  before do
    give_authority(zhangsan, "联盟管理")
    login_user(zhangsan)
  end

  describe "DELETE /api/v1/alliance_company_relationships/:id" do
    it "联盟删除公司" do
      expect { auth_delete :destroy, id: avengers.id, company_id: warner.id }
        .to change { avengers.reload.companies.count }.by(-1)
    end

    it "自愿退出联盟" do
      login_user(nolan)
      give_authority(nolan, "联盟管理")

      expect { auth_delete :destroy, id: avengers.id, company_id: warner.id }
        .to change { avengers.reload.companies.count }.by(-1)
    end

    it "非联盟盟主不能删除其他公司" do
      login_user(nolan)

      auth_delete :destroy, id: avengers.id, company_id: tianche.id

      expect(response_json[:message]).to be_present
    end
  end

  describe "PUT /api/v1/alliance_company_relationships/:id" do
    it "更新公司在联盟中的昵称" do
      nickname = "我是昵称"

      auth_put :update, id: avengers.id, company: { nickname: nickname }

      expect(
        AllianceCompanyRelationship.find_by(
          alliance_id: avengers.id, company_id: tianche.id
        ).nickname
      ).to eq nickname
    end
  end
end
