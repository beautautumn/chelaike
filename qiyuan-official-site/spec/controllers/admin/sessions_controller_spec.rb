# frozen_string_literal: true
require "rails_helper"

RSpec.describe Admin::SessionsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "returns http success" do
      post :create, params: { phone: "13911112222" }
      expect(response).to redirect_to(admin_path)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      delete :destroy
      expect(response).to redirect_to(new_admin_session_path)
    end
  end

  describe "GET #code" do
    it "returns http success" do
      xhr :get, :code
      expect(response).to have_http_status(:success)
    end
  end
end
