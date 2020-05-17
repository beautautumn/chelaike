require "rails_helper"

RSpec.describe V1::PublishSellersController do
  fixtures :all

  let(:github) { companies(:github) }
  let(:git) { users(:git) }

  before do
    login_user(git)
  end

  describe "GET /api/v1/publish_sellers" do
    it "销售员信息" do
      auth_get :index

      expect(response_json[:data]).to eq []
    end
  end
end
