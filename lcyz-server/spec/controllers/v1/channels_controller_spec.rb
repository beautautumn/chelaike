require "rails_helper"

RSpec.describe V1::ChannelsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:zhangsan) { users(:zhangsan) }
  let(:google_url) { "http://www.google.com" }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
    allow_any_instance_of(Channel).to receive(:wechat_qrcode_url).and_return(google_url)
  end

  describe "GET /api/v1/channels" do
    it "returns all channels for specify company" do
      auth_get :index

      result = {
        id: aodi_4s.id,
        name: aodi_4s.name,
        company_id: tianche.id,
        company_type: "Company",
        note: aodi_4s.note,
        wechat_qrcode_url: google_url,
        created_at: iso8601_format("2015-01-10")
      }

      expect(response_json[:data].first).to eq result
    end
  end

  describe "PUT /api/v1/channels/:id" do
    it "updates specify channel" do
      auth_put :update, id: aodi_4s.id,
                        channel: { name: "宝马4s店" }

      result = {
        data: {
          id: aodi_4s.id,
          name: "宝马4s店",
          company_id: tianche.id,
          company_type: "Company",
          note: aodi_4s.note,
          wechat_qrcode_url: google_url,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: aodi_4s.id,
                          channel: { name: "宝马4s店" }
      end
    end
  end

  describe "POST /api/v1/channels" do
    it "creates a channel" do
      auth_post :create,
                channel: {
                  name: "宝马4S店",
                  note: "还是宝马的好"
                }

      baoma_4s = tianche.channels.find_by(name: "宝马4S店")
      result = {
        id: baoma_4s.id,
        name: "宝马4S店",
        company_id: tianche.id,
        company_type: "Company",
        wechat_qrcode_url: google_url,
        note: "还是宝马的好"
      }

      expect(response_json[:data].slice!(:created_at)).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create,
                  channel: {
                    name: "宝马4S店",
                    note: "还是宝马的好"
                  }
      end
    end
  end

  describe "DELETE /api/v1/channels/:id" do
    it "deletes specify channel" do
      auth_delete :destroy, id: aodi_4s.id

      result = {
        data: {
          id: aodi_4s.id,
          name: aodi_4s.name,
          company_id: tianche.id,
          company_type: "Company",
          note: aodi_4s.note,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) { auth_delete :destroy, id: aodi_4s.id }
    end
  end
end
