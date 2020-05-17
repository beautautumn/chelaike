require "rails_helper"

RSpec.describe V1::Parallel::StylesController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { parallel_brands(:aodi) }
  let(:q7) { parallel_styles(:q7) }

  before do
    login_user(zhangsan)
  end

  describe "GET #index" do
    it "returns result" do
      auth_get :index
      expect(response_json[:data].first[:name]).to eq q7.name
    end
  end

  describe "GET #show" do
    it "returns result" do
      auth_get :show, id: q7.id
      expect(response_json[:data][:name]).to eq q7.name
    end

    it "includes images" do
      auth_get :show, id: q7.id
      expect(response_json[:data][:images]).to be_present
    end
  end
end
