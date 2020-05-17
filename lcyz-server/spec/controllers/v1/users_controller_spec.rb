require "rails_helper"

RSpec.describe V1::UsersController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:warner) { companies(:warner) }
  let(:nolan_disabled) { users(:nolan_disabled) }
  let(:username) { "DavidFincher" }
  let(:password) { "ILoveYourFilms." }
  let(:phone) { "18668237884" }
  let(:pixar) { shops(:pixar) }

  let(:user_params) do
    {
      username: username,
      name: "David Fincher",
      phone: phone,
      shop_id: pixar.id,
      password: password,
      email: "davidfincher@social.network",
      manager_id: nolan.id,
      company_id: warner.id,
      state: "enabled",
      is_alliance_contact: false,
      note: "u are not an asshole.u just try to be.",
      qrcode_url: "qrcode-url",
      self_description: "self description"
    }
  end
  let(:create_roles) do
    [
      authority_roles(:manager_warner),
      authority_roles(:salesman_warner)
    ]
  end

  before do
    login_user(nolan)
  end

  describe "POST /api/v1/users" do
    it "创建新员工，不指定权限" do
      auth_post :create, user: user_params

      expect(response_json[:data][:username]).to eq username
      expect(User.find_by(username: username).authenticate(password)).to be_truthy
    end

    it "创建新员工并指定角色权限" do
      user_params[:authority_type] = "role"
      user_params[:authority_role_ids] = create_roles

      auth_post :create, user: user_params

      expect(User.find_by(username: username).authority_roles.pluck(:name))
        .to eq create_roles.map(&:name)
    end
  end

  describe "PUT /api/v1/users/:id" do
    it "更新员工信息, 不更新权限" do
      authorities = nolan.authorities
      auth_put :update, id: nolan, user: { phone: phone }

      nolan.reload
      expect(response_json[:data][:phone]).to eq phone
      expect(nolan.reload.authorities).to eq authorities
    end

    it "添加MAC地址锁定" do
      auth_put :update, id: nolan,
                        user: {
                          phone: phone,
                          settings: { mac_address_lock: true },
                          mac_address: "123456"
                        }

      expect(nolan.reload.mac_address).to eq "123456"
      expect(nolan.mac_address_lock).to be_truthy
    end

    it "更新员工信息，更新角色权限" do
      warner_roles = [authority_roles(:manager_warner), authority_roles(:boss_warner)]

      auth_put :update, id: nolan,
                        user: { authority_role_ids: warner_roles }

      expect(nolan.reload.authority_roles.pluck(:name).sort!)
        .to eq warner_roles.map(&:name).sort!
    end

    it "更新员工信息，更新自定义权限" do
      auth_put :update, id: nolan,
                        user: {
                          authority_type: "custom",
                          authorities: ["测试权限"]
                        }

      expect(nolan.reload.authorities).to match_array %w(测试权限 车币充值)
    end

    it "上传用户头像" do
      avatar = "http://www.avatar.com"

      auth_put :update,
               id: nolan,
               user: {
                 avatar: avatar,
                 qrcode_url: "qrcode-url",
                 self_description: "self description"
               }

      expect(nolan.qrcode_url).to eq "qrcode-url"
      expect(nolan.self_description).to eq "self description"
      expect(nolan.reload.avatar).to eq avatar
      expect(nolan.authorities).not_to be_empty
    end

    it "增加跨店查看权限" do
      auth_put :update,
               id: nolan,
               user: { settings: { cross_shop_read: true } }

      authorities = %w(在库车辆查询 已出库车辆查询 联盟车辆查询 整备信息查看 牌证信息查看)
      expect(nolan.reload.cross_shop_authorities).to eq authorities
    end
  end

  describe "PUT /api/v1/users/:id/mobile_app_car_detail_menu" do
    it "修改手机app车辆详情页菜单" do
      menu = %w(basic_info public_praise)
      auth_put :mobile_app_car_detail_menu, id: nolan, user: { mobile_app_car_detail_menu: menu }

      expect(nolan.reload.mobile_app_car_detail_menu).to eq menu
    end
  end

  describe "POST /api/v1/users/feedback" do
    it "用户反馈" do
      feedback = "唉呀妈呀，你们这产品做的也老好了！"
      auth_post :feedback, user: { feedbacks_attributes: [{ note: feedback }] }

      expect(nolan.reload.feedbacks.first.note).to eq feedback
    end
  end

  describe "DELETE /api/v1/users/:id" do
    before do
      give_authority(nolan, "员工管理")
    end

    it "deletes specify user" do
      auth_delete :destroy, id: nolan_disabled

      expect do
        User.find(nolan_disabled.id)
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "deletes specify user expect owner" do
      auth_delete :destroy, id: nolan.id

      expect(User.find(nolan.id)).to be_present
    end
  end

  describe "POST /api/v1/users/:id/state" do
    it "disables specify user" do
      auth_put :state, id: nolan.id,
                       user: { state: "disabled" }

      expect(nolan.reload).to be_disabled
    end
  end

  describe "GET /api/v1/users" do
    it "获取所有用户" do
      auth_get :index

      binding.pry
      users = response_json[:data]
      expect(users.size).to eq 5
      expect(users.first).to have_key(:is_alliance_contact)
      expect(users.first).to have_key(:manager)
    end

    it "获取启用的用户" do
      auth_get :index, query: { state_eq: "enabled" }

      expect(response_json[:data].size).to eq 4
    end

    it "lists all active intentions count" do
      auth_get :index, intention: 1

      expect(response_json[:data]).to be_present
    end

    it "orders by state" do
      auth_get :index

      expect(response_json[:data].last[:id]).to eq nolan_disabled.id
    end
  end

  describe "GET /api/v1/users/me" do
    it "returns info of the specify user" do
      auth_get :me

      expect(response_json[:data][:id]).to eq nolan.id
      expect(response_json[:meta]).to be_present
    end
  end

  describe "GET /api/v1/users/selector" do
    it "lists all users" do
      auth_get :selector

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns specify user" do
      auth_get :show, id: nolan.id

      expect(response_json[:data][:id]).to eq nolan.id
    end
  end

  describe "PUT /api/v1/user/client_info" do
    it "updates client_info of user" do
      auth_put :client_info, user: { client_info: { version: 12 } }

      expect(nolan.reload.client_info).to eq("version" => "12")
    end
  end

  describe "GET /api/v1/users/:user_id/subordinate_users" do
    before do
      login_user(zhangsan)
    end

    it "lists all subordinate_users of specify user" do
      auth_get :subordinate_users, user_id: zhangsan.id

      ids = response_json[:data].map { |record| record[:id] }
      expect(ids).to contain_exactly(lisi.id)
    end
  end
end
