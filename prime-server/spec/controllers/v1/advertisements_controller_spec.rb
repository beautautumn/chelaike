require "rails_helper"

RSpec.describe V1::AdvertisementsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/advertisements" do
    it "gets ads list, filter disabled" do
      auth_get :index
      expect(response_json[:data].count).to eq 1
      expect(response_json[:data].first[:show_seconds]).to eq 5
    end
  end
end
