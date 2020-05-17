require "rails_helper"

RSpec.describe Open::V1::AccessTokensController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  describe "POST /api/open/v1/access_tokens" do
    it "获取access_token" do
      payload = { app_secret: tianche.app_secret }
      signature = JWT.encode payload, tianche.app_secret, "HS256"

      post :create, app_id: tianche.id, signature: signature

      expect(response_json[:data][:access_token]).to be_present
    end

    it "错误的signature不能获取access_token" do
      payload = { app_secret: "abcd" }
      signature = JWT.encode payload, "abcd", "HS256"

      post :create, app_id: tianche.id, signature: signature

      expect(response.status).to eq 401
    end
  end

  describe "GET /api/open/v1/ping" do
    it "ping pong" do
      access_app(tianche)
      open_get :ping

      expect(response.body).to eq "pong"
    end

    it "过期token无效" do
      get :ping, AutobotsToken: tianche.token
      travel_to(Time.zone.now + 1.day)

      expect(response.status).to eq 401
    end
  end
end
