# frozen_string_literal: true
require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  fixtures :all

  let(:user) { users(:zhangsan) }
  let(:username) { "Zhangsan" }
  let(:password) { "Zhangsan" }

  describe "POST create" do
    it "用户登录成功" do
      post :create, params: { user: { login: username, password: password } }

      expect(assigns(:user)).to eq user
      expect(response).to redirect_to(root_path)
      expect(response.status).to eq 302
    end

    it "用户不存在" do
      post :create, params: { user: { login: "wrong-name", password: password } }

      expect(assigns(:user)).to be_nil
      expect(response).to redirect_to(new_session_path)
      expect(response.status).to eq 302
    end
  end
end
