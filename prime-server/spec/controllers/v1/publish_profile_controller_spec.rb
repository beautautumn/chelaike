require "rails_helper"

RSpec.describe V1::PublishProfilesController do
  fixtures :all

  let(:github) { companies(:github) }
  let(:git) { users(:git) }

  before do
    login_user(git)
  end

  describe "GET /api/v1/publish_profile" do
    it "获取发布账号信息" do
      auth_get :show

      expect(response_json[:data][:che168]).not_to be_nil
    end
  end

  describe "PUT /api/v1/publish_profile" do
    it "配置发布账号" do
      allow(CarPublisher::Che168Worker::Helper).to receive(:login).and_return("")
      che168_username = "che168的账号"

      VCR.use_cassette("publish_profile_che168") do
        auth_put :update, che168: {
          data: {
            username: che168_username,
            password: "che168的密码"
          }
        }
      end

      expect(git.company.che168_profile.data["username"]).to eq che168_username
    end
  end

  describe "DELETE /api/v1/publish_profile" do
    it "解绑发布账号" do
      auth_delete :destroy, type: "che168"

      expect(git.company.che168_profile).to be_nil
    end
  end

  describe "GET /api/v1/publish_profile/validation" do
    it "查询配置的账号是否有效" do
      VCR.use_cassette("publish_profile_validation") do
        auth_get :validation
      end

      expect(response_json[:data][:che168]).to be_falsy
    end
  end
end
