require "rails_helper"

RSpec.describe V1::Chat::ConversationsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }

  before do
    login_user(zhangsan)
  end

  describe "#show" do
    it "返回聊天会话信息" do
      auth_get :index
      expect(response_json[:data]).to be_present
    end
  end

  describe "#update" do
    it "更新聊天会话信息" do
      auth_put :sync, target_id: nolan.id, conversation_type: "private",
                      is_top: true, is_blocked: true

      expect(response_json[:data][:is_top]).to be_truthy
      expect(response_json[:data][:is_blocked]).to be_truthy
    end
  end
end
