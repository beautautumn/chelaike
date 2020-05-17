require "rails_helper"

RSpec.describe V1::AlliancesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:github) { companies(:github) }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }

  before do
    give_authority(zhangsan, "联盟管理", "联盟车辆查询")
    login_user(zhangsan)
  end

  describe "get /api/v1/alliances/cars" do
    it "获取所有联盟的所有车辆" do
      auth_get :cars
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/alliances/cars/:id" do
    it "获取复仇者联盟中某辆车的信息" do
      auth_get :car, id: tumbler.id

      expect(response_json[:data][:allied]).to eq false
    end

    it "获取复仇者联盟中非本公司某辆车的信息" do
      login_user(nolan)
      give_authority(nolan, "联盟车辆查询")

      auth_get :car, id: aodi.id

      expect(response_json[:data][:allied]).to eq true
    end
  end

  describe "get /api/v1/alliances/companies" do
    it "获取当前公司的所有同盟公司" do
      auth_get :companies

      expect(response_json[:data]).to be_present
    end

    it "支持按照联盟id过滤" do
      auth_get :companies, query: { alliance_id_in: [avengers.id] }

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/alliances/companies_except_me" do
    it "获取当前公司的所有同盟公司, 不包括本公司" do
      auth_get :companies_except_me
      expect(response_json[:data].any? { |c| c[:name] == "天车二手车" }).not_to be_present
    end
  end

  describe "GET /api/v1/alliances/" do
    it "获取天车公司的所有联盟" do
      auth_get :index

      expect(response_json[:data].any? { |h| h[:name] == "复仇者联盟" }).to be_truthy
    end

    it "搜索天车公司的联盟" do
      auth_get :index, query: { name_or_companies_name_cont: "复仇者" }

      expect(response_json[:data].first[:name]).to eq avengers.name
    end
  end

  describe "GET /api/v1/alliances/:id" do
    it "获取联盟详情" do
      auth_get :show, id: avengers.id

      expect(response_json[:data][:name]).to eq avengers.name
      expect(response_json[:data][:companies].first[:nickname]).to be_present
    end
  end

  describe "POST /api/v1/alliances" do
    it "创建联盟" do
      name = "妇联"
      auth_post :create, alliance: { name: name },
                         invited_companies: [warner.id]

      expect(response_json[:data][:name]).to eq name
      expect(response_json[:data][:owner][:id]).to eq zhangsan.company_id
      expect(
        tianche.reload.alliances.find_by(name: "妇联").alliance_invitations.size
      ).to eq 1
    end
  end

  describe "PUT /api/v1/alliances/:id" do
    it "更新联盟" do
      name = "妇联"

      auth_put :update, id: avengers.id, alliance: { name: name }

      expect(response_json[:data][:name]).to eq name
    end

    it "非联盟盟主不可更新联盟" do
      login_user(nolan)
      auth_put :update, id: avengers.id, alliance: { name: "妇联" }

      expect(response.status).to eq 403
    end
  end

  describe "DELETE /api/v1/alliances/:id" do
    it "删除联盟" do
      auth_delete :destroy, id: avengers.id

      expect(avengers.reload.deleted_at).to be_present
    end
  end

  describe "PATCH chat_group" do
    context "开启聊天组" do
      it "可以开启这个聊天组" do
        VCR.use_cassette("rongcould/chat_group") do
          auth_patch :chat_group, id: avengers.id, state: "enable", type: "sale"

          expect(avengers.chat_groups.where(group_type: "sale").first.state).to eq "enable"
        end
      end
    end

    context "关闭聊天组" do
      it "可以关闭某个聊天组" do
        chat_group = avengers.chat_groups.where(group_type: "sale").first
        chat_group.update(state: "enable")
        auth_patch :chat_group, id: avengers.id, state: "disable", type: "sale"

        expect(chat_group.reload.state).to eq "disable"
      end
    end
  end
end
