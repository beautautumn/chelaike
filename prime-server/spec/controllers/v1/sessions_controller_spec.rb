require "rails_helper"

RSpec.describe V1::SessionsController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:username) { "Nolan" }
  let(:phone) { "18668237883" }
  let(:password) { "ThePrestige" }
  let(:invalid_password) { "Seven" }

  describe "POST /api/v1/sessions" do
    it "用户登录成功" do
      post :create, user: { login: username, password: password }

      user = response_json[:data]
      expect(user).to have_key(:token)
      expect(user).to have_key(:avatar)
      expect(user).to have_key(:company)
    end

    it "记录用户的device_number信息" do
      request.headers["AutobotsDeviceNumber"] = "asdf"
      request.headers["AutobotsPlatform"] = "IOS"

      post :create, user: { login: username, password: password }

      user = User.find_by(username: username)
      expect(user.current_device_number).to eq "asdf"
    end

    it "用户用手机登录成功" do
      post :create, user: { login: phone, password: password }

      expect(response_json[:data]).to have_key(:token)
    end

    context "用户登录失败" do
      it "用户输入错误密码" do
        post :create, user: { login: username, password: invalid_password }

        expect(response.status).to eq 401
      end

      it "用户是被禁用的" do
        nolan.update_columns(state: :disabled)
        post :create, user: { login: username, password: password }

        expect(response.status).to eq 401
      end
    end

    context "with locks" do
      before do
        nolan.update!(mac_address_lock: true, mac_address: "abc")
      end

      it "will login" do
        request.headers["AutobotsMacAddress"] = "abc"
        post :create, user: { login: username, password: password }

        expect(response.status).to eq 200
      end
    end
  end
end
