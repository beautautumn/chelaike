require "rails_helper"

RSpec.describe V1::CarRelativeStatisticsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/cars/:id/car_relative_statistic/sumup" do
    it "returns statistics" do
      auth_get :sumup, car_id: aodi.id

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/cars/:id/car_relative_statistic" do
    it "lists items" do
      auth_get :show, car_id: aodi.id, type: :checked_intentions

      expect(response_json[:data]).to be_present
    end
  end
end
