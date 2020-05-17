require "rails_helper"

RSpec.describe V1::Finance::ShopFeesController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche_shop_fee) { finance_shop_fees(:disney_shop_fee_j) }
  let(:disney) { shops(:disney) }

  before do
    give_authority(zhangsan, "财务管理")
    login_user(zhangsan)
  end

  describe "GET /api/v1/finance/shop_fees" do
    it "gets all results" do
      auth_get :index, query: { shop_id: disney.id }
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/finance/shop_fees/export" do
    it "export search result" do
      auth_get :export, query: { shop_id: disney.id }
      expect(response.status).to be 200
    end
  end

  describe "PUT /api/v1/finance/shop_fees/:id" do
    it "修改运营成和收益" do
      auth_put :update, id: tianche_shop_fee.id,
                        finance_shop_fee: {
                          location_rent_yuan: 35,
                          office_fee_yuan: 27,
                          note: "费用更新啦"
                        }
      expect(response_json[:data][:location_rent_yuan]).to eq 35
      expect(response_json[:data][:office_fee_yuan]).to eq 27
      expect(response_json[:data][:note]).to eq "费用更新啦"
    end
  end
end
