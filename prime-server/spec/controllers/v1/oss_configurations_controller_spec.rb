require "rails_helper"

RSpec.describe V1::OssConfigurationsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "POST /api/v1/oss_configuration" do
    it "creates a oss key" do
      allow_any_instance_of(AliyunOss).to receive(:oss_policy).and_return("abc")
      allow_any_instance_of(AliyunOss).to receive(:signature).and_return("cba")

      auth_post :create

      result = {
        data: {
          oss_key: ENV.fetch("ACCESS_KEY_ID"),
          policy: "abc",
          signature: "cba"
        }
      }

      expect(response_json).to eq result
    end
  end
end
