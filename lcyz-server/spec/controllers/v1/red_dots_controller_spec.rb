require "rails_helper"

RSpec.describe V1::RedDotsController do
  fixtures :users, :maintenance_records

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "#index" do
    it "returns 200" do
      auth_get :index

      expect(response.status).to eq 200
    end

    it "returns maintenance_record red dot" do
      auth_get :index

      expect(response_json[:data][:maintenance_record]).to eq 1
    end
  end
end
