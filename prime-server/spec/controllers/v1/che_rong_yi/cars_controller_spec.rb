require "rails_helper"

RSpec.describe V1::CheRongYi::CarsController do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:disney) { shops(:disney) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    zhangsan.update!(shop_id: disney.id)
    Car.all.update_all(shop_id: disney.id, loan_status: :noloan)
    login_user(zhangsan)
  end

  describe "GET index" do
    it "得到这个车辆里所有在库未质押车辆列表" do
      auth_get :index
      expect(response_json[:data].count).to eq 25
    end
  end
end
