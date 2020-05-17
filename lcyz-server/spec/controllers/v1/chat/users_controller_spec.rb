require "rails_helper"

RSpec.describe V1::Chat::UsersController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:nolan_disabled) { users(:nolan_disabled) }
  let(:username) { "DavidFincher" }
  let(:password) { "ILoveYourFilms." }
  let(:phone) { "18668237884" }
  let(:pixar) { shops(:pixar) }
  let(:alliance_avengers) { alliances(:avengers) }
  let(:alliance_gcd) { alliances(:gcd) }
  let(:tianche_sale) { chat_groups(:tianche_sale) }
  let(:zhangsan_lisi_private) { conversations(:zhangsan_lisi_private) }
  let(:zhangsan_tianche_sale_group) { conversations(:zhangsan_tianche_sale_group) }

  def construct_tianche_alliances
    tianche.alliance_company_relationships.destroy_all
    alliance_gcd.add_company(tianche)
    alliance_avengers.add_company(tianche)
  end

  before do
    construct_tianche_alliances
    login_user(zhangsan)
  end

  describe "POST rc_token" do
    it "返回用户对应的融云token" do
      VCR.use_cassette("rongcloud/user") do
        auth_post :rc_token
        data = response_json[:data]
        expect(data[:rc_token]).to be_present
      end
    end
  end

  describe "GET index" do
    context "本公司员工" do
      it "返回本公司里除去禁用的员工" do
        auth_get :index

        expect(response_json[:data]).to be_present
      end
    end

    context "选择某个联盟" do
      it "返回某个联盟里可以进行直聊的员工列表" do
        lisi.update(company: warner)
        give_authority(lisi, "联盟管理")

        auth_get :index, type: "alliance", alliance_id: alliance_avengers.id
        expect(response_json[:data]).to be_present
      end
    end
  end

  describe "GET show" do
    it "得到这个用户在这个私聊会话里的信息" do
      zhangsan_lisi_private.update(target_id: lisi.id)
      auth_get :show, id: lisi

      company = lisi.company
      shop = lisi.shop
      result = {
        id: lisi.id,
        nickname: "Lisi",
        phone: lisi.phone,
        avatar: lisi.avatar,
        is_top: true,
        is_blocked: false,
        rc_token: nil,
        company_id: company.id,
        company_name: company.name,
        company_address: company.address,
        shop_id: shop.id,
        shop_name: shop.name
      }

      expect(response_json[:data]).to eq result
    end

    context "有group_id" do
      it "得到某个用户在一个群聊里的具体信息，包括设置" do
        zhangsan_tianche_sale_group.update(target_id: tianche_sale.id)
        auth_get :show, id: zhangsan, group_id: tianche_sale.id
        expect(response_json[:data]).to be_present
      end
    end
  end

  describe "GET alliances" do
    it "返回这个员工所在公司加入的联盟列表" do
      auth_get :alliances

      expect(response_json[:data].count).to eq 2
    end
  end

  describe "GET groups" do
    it "返回当前用户加入的群组列表" do
      auth_get :groups
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET all_users" do
    it "根据传入的user_ids得到这些用户的具体信息" do
      auth_get :all_users, user_ids: [nolan, zhangsan, lisi].map(&:id)
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET query_users" do
    it "搜索用户" do
      auth_get :query_users, query: { name_cont: "lis" }
      expect(response_json[:data].first[:id]).to eq lisi.id
    end
  end

  describe "GET system_messagers" do
    before do
      User.create!(id: -100, username: "statistics_messager", name: "统计消息",
                   phone: "statistics_messager", password: "e5f732bea0edc282fd9d")
      User.create!(id: -200, username: "stock_messager", name: "库存消息",
                   phone: "stock_messager", password: "463af81dca326aff30fb")
      User.create!(id: -300, username: "customer_messager", name: "客户消息",
                   phone: "customer_messager", password: "77e304e80b2078e488c7")
      User.create!(id: -400, username: "system_messager", name: "系统消息",
                   phone: "system_messager", password: "fa494f72fd883fb9c9cf")
    end

    it "得到所有系统消息用户" do
      auth_get :system_messagers
      expect(response_json[:data].count).to eq 4
    end
  end
end
