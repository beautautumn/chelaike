require "rails_helper"

RSpec.describe V1::Chat::GroupsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:tianche_sale) { chat_groups(:tianche_sale) }
  let(:avengers_sale) { chat_groups(:avengers_sale) }
  let(:avengers_acquisition) { chat_groups(:avengers_acquisition) }
  let(:warner) { companies(:warner) }
  let(:avengers) { alliances(:avengers) }

  before do
    login_user(zhangsan)
  end

  describe "GET company" do
    it "返回公司群组信息" do
      auth_get :company, id: tianche_sale.id
      expect(response_json[:data][:id]).to eq tianche_sale.id
      expect(response_json[:data][:users].size).to eq 2
    end
  end

  describe "GET show" do
    it "得到这个群组的基本信息" do
      auth_get :show, id: tianche_sale
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET #alliance" do
    before do
      avengers.add_company(warner)
    end

    context "收购群" do
      it "返回信息里users是单一层结构" do
        auth_get :alliance, id: avengers_acquisition.id
        expect(response_json[:data][:id]).to eq avengers_acquisition.id
      end
    end

    context "销售群" do
      it "返回信息里users要根据公司分层" do
        auth_get :alliance, id: avengers_sale.id
        expect(response_json[:data][:id]).to eq avengers_sale.id
        expect(response_json[:data][:companies].size).to eq 2
      end
    end
  end

  describe "#name" do
    it "修改群名称" do
      VCR.use_cassette("rongcould/chat_group") do
        auth_patch :name, id: tianche_sale.id, name: "嘻嘻嘻"

        expect(tianche_sale.reload.name).to eq "嘻嘻嘻"
        expect(response_json[:message]).to eq "ok"
      end
    end
  end

  describe "#nickname" do
    it "修改群昵称" do
      auth_patch :nickname, id: tianche_sale.id, nickname: "嘻嘻嘻"

      expect(zhangsan.group_chat_info(tianche_sale)[:nickname]).to eq "嘻嘻嘻"
      expect(response_json[:message]).to eq "ok"
    end
  end

  describe "#join_users" do
    it "添加用户" do
      VCR.use_cassette("rongcould/chat_group", record: :new_episodes) do
        auth_post :join_users, id: tianche_sale.id, user_ids: [nolan.id]
        expect(response_json[:message]).to eq "ok"
        expect(
          ChatSession.exists?(
            user_id: nolan.id,
            target_id: tianche_sale.id,
            target_type: ChatGroup.name
          )
        ).to be_truthy
      end
    end
  end

  describe "POST quit_users" do
    it "删除用户" do
      VCR.use_cassette("rongcould/chat_group", record: :new_episodes) do
        auth_post :quit_users, id: tianche_sale.id, user_ids: [lisi.id]
        expect(response_json[:message]).to eq "ok"
        expect(
          ChatSession.exists?(
            user_id: lisi.id,
            target_id: tianche_sale.id,
            target_type: ChatGroup.name
          )
        ).to be_falsey
      end
    end
  end

  describe "#users" do
    it "选择添加用户列表" do
      auth_get :users, id: tianche_sale.id, scope: "not_in_group"
      expect(response_json[:data].size).to eq 2
    end

    it "选择删除用户列表" do
      auth_post :users, id: tianche_sale.id, type: "in_group"
      expect(response_json[:data].first[:id]).to eq lisi.id
    end
  end

  describe "#all_users" do
    it "返回公司列表" do
      auth_get :all_users, id: tianche_sale.id
      expect(response_json[:data][:type]).to eq "company"
      expect(response_json[:data][:companies].first[:users]).to be_present
    end

    it "返回联盟列表" do
      auth_get :all_users, id: avengers_sale.id
      expect(response_json[:data][:type]).to eq "alliance"
      expect(response_json[:data][:companies].first[:users]).to be_present
    end
  end
end
