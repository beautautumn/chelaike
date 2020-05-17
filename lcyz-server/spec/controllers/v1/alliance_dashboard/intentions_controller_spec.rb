require "rails_helper"

RSpec.describe V1::AllianceDashboard::IntentionsController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:tianche) { companies(:tianche) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:aodi_4s) { channels(:alliance_aodi_4s) }
  let(:aodi_5s) { channels(:alliance_aodi_5s) }
  let(:aodi) { cars(:aodi) }
  let(:alliance_seeking_aodi) { intentions(:alliance_seeking_aodi) }

  let(:seek_params) do
    {
      customer_name: "super man",
      customer_phone: "222",
      customer_phones: %w(191201 220001),
      gender: "male",
      province: "浙江",
      city: "杭州",
      intention_type: "seek",
      intention_level_id: intention_level_a.id,
      channel_id: aodi_4s.id,
      intention_note: "随便说点什么",
      seeking_cars: [
        {
          brand_name: "奥迪",
          series_name: "A6"
        },
        {
          brand_name: "大众",
          series_name: "宝来"
        }
      ],
      minimum_price_wan: 20,
      maximum_price_wan: 20
    }
  end

  before do
    give_authority(zhangsan, "求购客户管理")
    give_authority(lisi, "求购客户管理")
    login_user(alliance_zhangsan)
  end

  describe "GET index" do
    before do
      give_authority(alliance_zhangsan, "全部客户管理")
      login_user(alliance_zhangsan)
    end

    it "列出所有联盟创建的意向" do
      service = AllianceCompanyService::Intentions::Create.new(
        alliance_zhangsan, seek_params.merge(state: :untreated, alliance_state: :untreated)
      )

      service.create

      auth_get :index
      expect(response_json[:data].count).to eq 1
    end
  end

  describe "GET show" do
    it "returns detail for intention" do
      auth_get :show, id: alliance_seeking_aodi.id

      expect(response_json[:data][:id]).to eq alliance_seeking_aodi.id
    end
  end

  describe "GET export" do
    it "导出联盟创建的意向" do
      auth_get :export
      expect(response.status).to be 200
    end
  end

  describe "DELETE destroy" do
    it "returns detail after delete intention" do
      alliance_seeking_aodi.update(alliance_company_id: alliance_zhangsan.company_id)
      auth_delete :destroy, id: alliance_seeking_aodi.id
      expect(Intention.find_by(id: alliance_seeking_aodi.id)).to be_nil
    end
  end

  describe "POST create" do
    before do
      Message.destroy_all
      give_authority(alliance_zhangsan, "全部客户管理")
      login_user(alliance_zhangsan)
    end

    it "创建一条求购意向，属于创建它的这个联盟管理员" do
      auth_post :create, intention: seek_params.merge(state: :untreated)
      intention = Intention.last
      expect(intention.creator).to eq alliance_zhangsan
      expect(intention.alliance_assignee).to eq alliance_zhangsan
    end
  end

  describe "PUT update" do
    before do
      Message.destroy_all
      give_authority(alliance_zhangsan, "全部客户管理")
      login_user(alliance_zhangsan)
    end

    it "更新这条意向信息" do
      create_service = AllianceCompanyService::Intentions::Create.new(
        alliance_zhangsan,
        seek_params.merge(state: :untreated)
      )
      create_service.create
      intention = create_service.intention

      auth_put :update, id: intention, intention: seek_params.merge(channel_id: aodi_5s.id)

      expect(intention.reload.channel).to eq aodi_5s
    end
  end

  describe "PUT assign" do
    before do
      Message.destroy_all
      give_authority(alliance_zhangsan, "全部客户管理")
      login_user(alliance_zhangsan)
    end

    it "这个车商里有这几条意向" do
      give_authority(zhangsan, "全部客户管理")

      service = AllianceCompanyService::Intentions::Create.new(
        alliance_zhangsan, seek_params.merge(state: :untreated)
      )

      intention = service.create.intention

      daily_service = DailyManagement::Sale::ManagerService.new(zhangsan)
      expect do
        auth_put :batch_assign, intention_ids: [intention.id], company_id: tianche.id
      end.to change { daily_service.untreated_intentions.count }.by 1
    end
  end
end
