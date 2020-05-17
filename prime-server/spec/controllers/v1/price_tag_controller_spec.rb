require "rails_helper"

RSpec.describe V1::PriceTagsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/cars/:car_id/price_tag" do
    it "获取价签参数" do
      auth_get :show, car_id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.id
    end
  end
end
