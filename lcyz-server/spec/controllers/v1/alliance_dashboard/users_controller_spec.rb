require "rails_helper"

RSpec.describe V1::AllianceDashboard::UsersController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }

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

  let(:authority_roles) do
    [
      alliance_company_authority_roles(:alliance_manager_warner),
      alliance_company_authority_roles(:alliance_salesman_warner)
    ]
  end

  def login_manager(user = alliance_zhangsan)
    give_authority(user, "员工管理")
    login_user(user)
  end

  describe "GET index" do
    before do
      login_user(alliance_zhangsan)
    end

    it "列出这家联盟公司里的所有员工" do
      auth_get :index

      users = response_json[:data]
      expect(users.count).to eq 2
    end

    it "列出所有启用状态的员工" do
      alliance_lisi.update_columns(state: "disabled")
      alliance_zhangsan.update_columns(state: "enabled")

      auth_get :index, query: { state_eq: "enabled" }

      users = response_json[:data]
      expect(users.count).to eq 1
      expect(users.first.fetch(:id)).to eq alliance_zhangsan.id
    end
  end

  describe "GET show" do
    before do
      give_authority(alliance_zhangsan, "员工管理")
      login_user(alliance_zhangsan)
    end

    it "得到这个用户的详情" do
      auth_get :show, id: alliance_zhangsan
      expect(response_json[:data].keys).to include :authorities
    end
  end

  describe "POST create" do
    context "current_user has the authority" do
      before do
        login_manager
      end

      it "创建一个员工" do
        user_params[:authority_type] = "role"
        user_params[:authority_role_ids] = authority_roles.map(&:id)

        auth_post :create, user: user_params

        expect(AllianceCompany::User.count).to eq 3
        user_data = response_json[:data]
        expect(user_data).to have_key(:alliance_company)
        expect(user_data).to have_key(:manager)
      end
    end

    context "current_user does not hasve the authority" do
      before do
        login_user(alliance_zhangsan)
      end

      it "forbiddened" do
        user_params[:authority_type] = "role"
        user_params[:authority_role_ids] = authority_roles.map(&:id)

        auth_post :create, user: user_params

        expect(AllianceCompany::User.count).to eq 2
      end
    end
  end

  describe "PUT update" do
    def send_request
      warner_roles = [alliance_company_authority_roles(:alliance_salesman_warner)]
      auth_put :update, id: alliance_lisi,
                        user: { phone: "12345677889", authority_role_ids: warner_roles.map(&:id),
                                authority_type: "role"
      }
    end

    context "当前用户有员工管理权限" do
      before do
        login_manager
      end

      it "updates the user" do
        send_request
        alliance_lisi.reload
        expect(alliance_lisi.phone).to eq "12345677889"
        expect(alliance_lisi.authorities).to match_array ["在库车辆查询"]
      end

      it "可以删除这个用户的角色及权限" do
        alliance_lisi.update(
          authorities: %w(在库车辆查询 车辆信息编辑),
          authority_role_ids: authority_roles.map(&:id)
        )
        auth_put :update, id: alliance_lisi,
                          user: { phone: alliance_lisi.phone,
                                  authority_role_ids: [],
                                  authorities: [],
                                  authority_type: "role"
        }
        alliance_lisi.reload
        expect(alliance_lisi.authority_roles).to eq []
        expect(alliance_lisi.authorities).to eq []
      end
    end

    context "当前用户没有员工管理权限" do
      it "不能操作" do
        login_user(alliance_zhangsan)

        send_request

        alliance_lisi.reload
        expect(response.status).to eq 403
      end
    end
  end

  describe "DELETE destoy" do
    context "当前用户有员工管理权限" do
      before do
        login_manager
      end

      it "软删除这个用户" do
        auth_delete :destroy, id: alliance_lisi
        expect(AllianceCompany::User.find_by(username: "alliance_lisi")).to be_nil
      end
    end

    context "当前用户没有员工管理权限" do
      it "不能操作" do
        login_user(alliance_zhangsan)
        auth_delete :destroy, id: alliance_lisi
        expect(AllianceCompany::User.find_by(username: "alliance_lisi")).to be_present
      end
    end
  end

  describe "PUT state" do
    context "当前用户有员工管理权限" do
      before do
        login_manager
      end

      it "updates the user's state" do
        auth_put :state, id: alliance_lisi, user: { state: "disabled" }
        expect(alliance_lisi.reload.state).to eq "disabled"
      end
    end

    context "当前用户没有员工管理权限" do
      before do
        login_user(alliance_zhangsan)
      end

      it "不能操作" do
        auth_put :state, id: alliance_lisi, user: { state: "disabled" }
        expect(response.status).to eq 403
      end
    end
  end

  describe "GET me" do
    before do
      login_user(alliance_zhangsan)
    end

    it "得到这个用户的基本信息" do
      auth_get :me

      expect(response_json[:data][:id]).to eq alliance_zhangsan.id
    end
  end
end
