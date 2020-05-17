require "rails_helper"

RSpec.describe V1::AuthoritiesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:manager)  { authority_roles(:manager) }
  let(:salesman) { authority_roles(:salesman) }
  let(:disney) { shops(:disney) }

  before do
    give_authority(zhangsan, "员工管理")
    login_user(zhangsan)
  end

  describe "GET /api/v1/users/:user_id/authorities" do
    it "return user's authority info" do
      auth_get :index, user_id: zhangsan.id

      expect(response_json[:data][:id]).to eq zhangsan.id
    end
  end

  describe "GET /api/v1/authorities" do
    it "returns all authorities" do
      auth_get :index

      expect(response_json[:data].first[:category]).to eq "在库车辆"
      expect(response_json[:data].first[:authorities].first[:name]).to eq "在库车辆查询"
    end
  end

  describe "GET /api/v1/users/:user_id/authority_roles" do
    it "returns all authority_roles for specify user" do
      auth_get "authority_roles", user_id: zhangsan.id

      expect(response_json[:data][:id]).to eq zhangsan.id

      expect(response_json[:data][:authority_roles].size).to eq 1
    end
  end

  describe "POST /api/v1/users/:user_id/authorities" do
    it "appends salesman role to zhangsan" do
      auth_post :create, user_id: zhangsan.id,
                         user: { authority_role_id: salesman.id }

      expect(response_json[:data][:authority_roles].size).to eq 2
    end
  end

  describe "DELETE /api/v1/users/:user_id/authorities" do
    it "delete manager tag for zhangsan" do
      expect do
        auth_delete :destroy, user_id: zhangsan.id,
                              user: { authority_role_id: manager.id }
      end.to change { zhangsan.reload.authority_roles.size }.by(-1)
    end
  end

  describe "PUT /api/v1/users/:user_id/authorities/custom" do
    it "customizes authorities" do
      auth_put :custom, user_id: zhangsan.id,
                        user: { authorities: %w(库存量统计 销售员业绩) }

      expect(zhangsan.reload.authorities).to match_array %w(库存量统计 销售员业绩 车币充值).sort!
    end
  end
end
