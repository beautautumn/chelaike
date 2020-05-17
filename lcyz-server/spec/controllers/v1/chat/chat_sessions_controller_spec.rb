require "rails_helper"

RSpec.describe V1::Chat::ChatSessionsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:tianche_sale) { chat_groups(:tianche_sale) }
  let(:avengers_sale) { chat_groups(:avengers_sale) }
  let(:zhangsan_chat) { chat_sessions(:zhangsan_chat) }
  let(:lisi_chat) { chat_sessions(:lisi_chat) }
  let(:zhangsan_alliance_chat) { chat_sessions(:zhangsan_alliance_chat) }

  before do
    login_user(zhangsan)
  end

  describe "GET info" do
    it "得到对应的nickname, group_name" do
      auth_get :info, user_id: zhangsan.id, group_id: tianche_sale.id

      result = {
        user_id: zhangsan.id.to_s, group_id: tianche_sale.id.to_s,
        nickname: "jeheh", group_name: "天车二手车销售群",
        logo: nil
      }

      expect(response_json[:data]).to eq result
    end
  end

  describe "GET batch_infos" do
    it "得到对应的nickname, group_name" do
      auth_get :batch_infos, data: [
        { user_id: zhangsan.id, group_id: tianche_sale.id },
        { user_id: lisi.id, group_id: tianche_sale.id },
        { user_id: zhangsan.id, group_id: avengers_sale.id }
      ]

      result = [
        { user_id: zhangsan.id.to_s, group_id: tianche_sale.id.to_s,
          nickname: "jeheh", group_name: "天车二手车销售群" },
        { user_id: lisi.id.to_s, group_id: tianche_sale.id.to_s,
          nickname: "lisi_tianche_sale_nickname", group_name: "天车二手车销售群" },
        { user_id: zhangsan.id.to_s, group_id: avengers_sale.id.to_s,
          nickname: "haha", group_name: "复仇者联盟销售群" }
      ]

      expect(response_json[:data]).to eq result
    end
  end
end
