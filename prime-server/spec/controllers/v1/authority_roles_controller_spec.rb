require "rails_helper"

RSpec.describe V1::AuthorityRolesController do
  # TODO: 只有有管理权限的人才能管理权限
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:manager) { authority_roles(:manager) }
  let(:salesman) { authority_roles(:salesman) }

  before do
    give_authority(zhangsan, "角色管理")
    login_user(zhangsan)
  end

  describe "GET /api/v1/authority_roles" do
    it "returns all authority_roles for specify company" do
      auth_get :index, company_id: tianche.id

      result = {
        data: [
          {
            id: manager.id,
            name: "经理",
            note: "经理",
            created_at: iso8601_format("2015-01-10"),
            authorities: [
              "员工权限管理"
            ]
          },
          {
            id: salesman.id,
            name: "销售员",
            note: "销售员",
            created_at: iso8601_format("2015-01-10"),
            authorities: [
              "在库车辆查询"
            ]
          }
        ]
      }

      expect(response_json).to eq result
    end
  end

  describe "GET /api/v1/authority_roles/:id" do
    it "获取角色详情" do
      auth_get :show, id: manager.id

      result = {
        data: {
          id: manager.id,
          name: "经理",
          note: "经理",
          created_at: iso8601_format("2015-01-10"),
          authorities: [
            "员工权限管理"
          ]
        }
      }

      expect(response_json).to eq result
    end
  end

  describe "PUT /api/v1/authority_roles/:id" do
    it "更新角色信息" do
      authorities = %w(我勒个擦 还真全部更新了)
      auth_put :update, id: manager.id, authority_role: {
        name: "我被更新了", note: "我真的被更新了？？",
        authorities: authorities
      }

      expect(manager.reload.authorities.sort!).to eq authorities.sort!
      expect(zhangsan.reload.authorities).to include("我勒个擦")
    end

    it "将角色权限清空" do
      auth_put :update, id: manager.id, authority_role: {
        name: "我被更新了", note: "我真的被更新了？？",
        authorities: []
      }

      expect(manager.reload.authorities).to be_empty
    end
  end

  describe "POST /api/v1/authority_roles" do
    it "creates a new authority_role if name is present" do
      auth_post :create, authority_role: {
        name: "收购员", note: "收购员",
        authorities: %w(收了个购 购了个收)
      }

      authority_role = tianche.authority_roles
                              .find_by(name: "收购员")

      expect(response_json[:data][:authorities].sort!)
        .to eq authority_role.authorities.sort!
      expect(response_json[:data][:name]).to eq authority_role.name
      expect(response_json[:data][:note]).to eq authority_role.note
      expect(response_json[:data][:company][:id]).to eq tianche.id
    end

    it "can't not create authority_role if name is duplicate" do
      auth_post :create, authority_role: { name: "销售员" }

      result = {
        message: "参数校验不通过",

        errors: {
          authority_role: {
            name: ["权限角色名称已经被使用"]
          }
        }
      }

      expect(response_json).to eq result
    end
  end

  describe "DELETE /api/v1/authority_roles/:id" do
    it "deletes a specify authority_role" do
      auth_delete :destroy, id: manager.id

      expect { AuthorityRole.find(manager.id) }.to(
        raise_error(ActiveRecord::RecordNotFound)
      )
    end
  end
end
