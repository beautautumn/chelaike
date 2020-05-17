# frozen_string_literal: true
require "rails_helper"

RSpec.describe WechatsController, type: :controller do
  describe "GET #authorization" do
    it "returns auth data" do
      get :authorization
      expect(response_json[:data][:wechat_app]).to be_present
    end
  end
end
