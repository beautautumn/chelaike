require "rails_helper"

RSpec.describe V1::AllianceDashboard::AuthorityRolesController do
  fixtures "alliance_company/users", "alliance_company/companies"

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

  describe "GET index" do
    before do
      alliance_tianche.authority_roles.create(name: "超级管理员")
      alliance_tianche.authority_roles.create(name: "客服")

      give_authority(alliance_zhangsan, "角色管理")
      login_user(alliance_zhangsan)
    end

    it "得到这家联盟公司创建的角色" do
      auth_get :index
      expect(response_json[:data].count).to eq 2
    end
  end

  describe "POST create" do
    context "the user has the authority to create roles" do
      it "creates a new role" do
        give_authority(alliance_zhangsan, "角色管理")
        login_user(alliance_zhangsan)

        auth_post :create, authority_role: {
          name: "管理员", note: "管理员",
          authorities: %w(在库车辆查询 车辆信息编辑)
        }

        authority_role = alliance_tianche.authority_roles
                                         .find_by(name: "管理员")

        data = response_json[:data]
        expect(alliance_tianche.authority_roles).to include(authority_role)
        expect(data[:name]).to eq "管理员"
        expect(data).to have_key(:alliance_company)
      end
    end

    context "the user has no authority" do
      it "can not create a new role" do
        login_user(alliance_zhangsan)
        auth_post :create, authority_role: {
          name: "管理员", note: "管理员",
          authorities: %w(在库车辆查询 车辆信息编辑)
        }

        authority_role = alliance_tianche.authority_roles
                                         .find_by(name: "管理员")
        expect(alliance_tianche.authority_roles).not_to include(authority_role)
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @superman_role = alliance_tianche.authority_roles.create(name: "超级管理员")
      @service_role = alliance_tianche.authority_roles.create(name: "客服")
    end

    context "当前用户有权限" do
      before do
        give_authority(alliance_zhangsan, "角色管理")
        login_user(alliance_zhangsan)
      end

      it "成功删除这个角色" do
        auth_delete :destroy, id: @service_role
        expect(alliance_tianche.reload.authority_roles).not_to include @service_role
      end
    end

    context "当前用户没有权限" do
      before do
        login_user(alliance_zhangsan)
      end

      it "不能操作" do
        auth_delete :destroy, id: @service_role
        expect(response.status).to eq 403
      end
    end
  end
end
