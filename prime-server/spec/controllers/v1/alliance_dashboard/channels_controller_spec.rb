require "rails_helper"

RSpec.describe V1::AllianceDashboard::ChannelsController, type: :controller do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:alliance_channel) { channels(:alliance_aodi_4s) }

  let(:tianche) { companies(:tianche) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:zhangsan) { users(:zhangsan) }
  let(:google_url) { "http://www.google.com" }

  before do
    give_authority(alliance_zhangsan, "业务设置")
    login_user(alliance_zhangsan)
  end

  describe "GET index" do
    it "列出所有这家联盟公司的渠道" do
      auth_get :index
      expect(response_json[:data].count).to eq 4
    end
  end

  describe "POST create" do
    it "creates a new channel" do
      auth_post :create,
                channel: {
                  name: "宝马4S店",
                  note: "还是宝马的好"
                }

      channel = alliance_tianche.channels.find_by(name: "宝马4S店")

      expect(channel).to be_persisted
      expect(response_json[:data][:id]).to eq channel.id
    end
  end

  describe "PUT update" do
    it "updates the channel" do
      updated_name = "新的名字"
      auth_put :update, id: alliance_channel,
                        channel: {
                          name: updated_name,
                          note: "还是宝马的好"
                        }
      expect(alliance_channel.reload.name).to eq updated_name
    end
  end

  describe "DELETE destroy" do
    before do
      give_authority(alliance_zhangsan, "业务设置")
    end

    it "删除一个渠道" do
      channel = alliance_tianche.channels.create(name: "channels1")
      auth_delete :destroy, id: channel

      expect(alliance_tianche.reload.channels).not_to include channel
    end
  end

  describe "GET company_index" do
    it "得到某个公司里设置的渠道列表" do
      auth_get :company_index, id: tianche.id

      ids = response_json[:data].map { |data| data.fetch(:id) }
      expect(ids).to match_array tianche.channels.map(&:id)
    end
  end
end
