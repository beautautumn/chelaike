require "rails_helper"

RSpec.describe AllianceCompanyService::User::CRUD do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }

  let(:phone) { "11111111111" }
  let(:username) { "alliance_user" }

  let(:user_params) do
    {
      username: username,
      name: "David Fincher",
      phone: phone,
      password: "password",
      email: "davidfincher@social.network",
      note: "一个简单的测试用户"
    }
  end

  let(:updated_params) do
    {
      username: username,
      name: "David Fincher",
      phone: phone,
      password: "password",
      email: "davidfincher@social.network",
      note: "一个简单的测试用户"
    }
  end

  let(:authority_roles) do
    [
      alliance_company_authority_roles(:alliance_manager_warner),
      alliance_company_authority_roles(:alliance_salesman_warner)
    ]
  end

  let(:service) { AllianceCompanyService::User::CRUD.new(alliance_zhangsan, user_params) }

  def update_service(operator = alliance_zhangsan)
    updated_params[:authority_type] = "role"
    updated_params[:authority_role_ids] = authority_roles.map(&:id)

    AllianceCompanyService::User::CRUD.new(
      operator, updated_params
    )
  end

  describe "#create" do
    context "has the authority" do
      before do
        give_authority(alliance_zhangsan, "员工管理")
      end

      it "创建一个没有权限的员工" do
        expect do
          service.create
        end.to change { AllianceCompany::User.count }.by(1)
      end

      it "创建一个有权限的员工" do
        user_params[:authority_type] = "role"
        user_params[:authority_role_ids] = authority_roles.map(&:id)

        service.create

        user = AllianceCompany::User.find_by(
          username: username
        )
        expect(user.authorities).to match_array %w(在库车辆查询 车辆信息编辑)
      end
    end

    context "does not have the authority" do
      it "raises error" do
        expect do
          service.create
        end.to raise_error(
          AllianceCompanyService::User::CRUD::CreateError, "没有员工管理权限"
        )
      end
    end
  end

  describe "#update" do
    context "有员工管理权限" do
      before do
        give_authority(alliance_zhangsan, "员工管理")
      end

      it "可以更新其他员工" do
        updated_user = update_service.update(alliance_lisi)

        expect(updated_user.username).to eq username
        expect(updated_user.phone).to eq phone
        expect(updated_user.id).to eq alliance_lisi.id
        expect(updated_user.authorities).to match_array %w(在库车辆查询 车辆信息编辑)
      end

      it "删除角色" do
        alliance_lisi.update(authorities: %w(在库车辆查询 车辆信息编辑))

        updated_params = {
          username: username,
          name: "David Fincher",
          phone: phone,
          password: "password",
          email: "davidfincher@social.network",
          note: "一个简单的测试用户",
          authority_type: "role",
          authority_role_ids: [],
          authorities: []
        }

        service = AllianceCompanyService::User::CRUD.new(alliance_zhangsan, updated_params)

        service.update(alliance_lisi)

        alliance_lisi.reload
        expect(alliance_lisi.authority_role_ids).to eq []
        expect(alliance_lisi.authorities).to eq []
      end
    end

    context "没有员工管理权限" do
      it "不能更新其他员工" do
        expect do
          update_service.update(alliance_lisi)
        end.to raise_error(
          AllianceCompanyService::User::CRUD::UpdateError, "没有员工管理权限"
        )
      end
    end

    context "更新自己" do
      it "可以更新自己" do
        updated_user = update_service(alliance_lisi).update(alliance_lisi)

        expect(updated_user.username).to eq username
        expect(updated_user.phone).to eq phone
        expect(updated_user.id).to eq alliance_lisi.id
        expect(updated_user.authorities).to match_array %w(在库车辆查询 车辆信息编辑)
      end
    end
  end
end
