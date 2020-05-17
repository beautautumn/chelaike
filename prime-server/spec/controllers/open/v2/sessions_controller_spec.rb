require "rails_helper"

RSpec.describe Open::V2::SessionsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:code) { "123456" }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/sessions/verification_code" do
    it "staff not exist" do
      open_get :verification_code, phone: "not exist"
      expect(response_json[:msg]).to eq "用户不存在"
    end

    it "staff had no right" do
      open_get :verification_code, phone: zhangsan.phone
      expect(response_json[:msg]).to eq "用户无微店管理权限"
    end
  end

  describe "POST /api/open/v2/sessions/verify" do
    it "staff not exist" do
      open_post :verify, phone: "not exist"
      expect(response_json[:msg]).to eq "用户不存在"
    end
    it "staff had no right" do
      open_post :verify, phone: zhangsan.phone
      expect(response_json[:msg]).to eq "用户无微店管理权限"
    end
    it "wrong code" do
      open_post :verify, phone: lisi.phone, code: code
      expect(response_json[:msg]).to eq "验证码无效"
    end
    it "verify code" do
      lisi.update_columns(
        pass_reset_token: code,
        pass_reset_expired_at: Time.zone.now + 1.hour
      )

      open_post :verify, phone: lisi.phone, code: code
      expect(response_json[:msg]).to eq "ok"
    end
  end
end
