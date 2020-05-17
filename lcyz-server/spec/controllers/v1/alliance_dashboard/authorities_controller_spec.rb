require "rails_helper"

RSpec.describe V1::AllianceDashboard::AuthoritiesController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

  describe "GET index" do
    before do
      give_authority(alliance_zhangsan, "角色管理", "员工管理")
      login_user(alliance_zhangsan)
    end

    context "传入某用户的ID" do
      it "得到这个用户的权限" do
        auth_get :index, user_id: alliance_zhangsan
        expect(response_json[:data][:authorities]).to match_array %w(角色管理 员工管理)
      end
    end

    context "不传特定用户ID" do
      it "得到所有权限" do
        auth_get :index
        expect(response_json[:data]).to eq AllianceCompany::User.authorities_hash
      end
    end
  end
end
