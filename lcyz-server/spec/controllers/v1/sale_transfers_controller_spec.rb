require "rails_helper"

RSpec.describe V1::SaleTransfersController do
  fixtures :all

  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    give_authority(zhangsan, "牌证信息录入")
    login_user(zhangsan)
  end

  describe "PUT /api/v1/cars/:car_id/sale_transfer" do
    before do
      auth_put :update, car_id: aodi.id,
                        sale_transfer: {
                          commercial_insurance: true,
                          state: :transfering,
                          total_transfer_fee_yuan: 20
                        }
    end

    it "updates the specify sale_transfer" do
      sale_transfer = aodi.sale_transfer.reload

      expect(sale_transfer.state).to eq "transfering"
      expect(sale_transfer.commercial_insurance).to be_truthy
      expect(sale_transfer.total_transfer_fee_yuan).to eq 20
    end

    it "syncs total_transfer_fee_yuan" do
      expect(aodi.stock_out_inventory.total_transfer_fee_yuan).to eq 20
    end
  end
end
