require "rails_helper"

RSpec.describe V1::AcquisitionTransfersController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    give_authority(zhangsan, "牌证信息录入", "牌证信息查看")
    login_user(zhangsan)
  end

  describe "GET /api/v1/cars/transfer_records" do
    it "获取牌证管理列表" do
      auth_get :index

      expect(response_json[:data].size).to be > 0
    end
  end

  describe "PUT /api/v1/cars/:car_id/acquisition_transfer" do
    it "creates a acquisition_transfer" do
      auth_put :update, car_id: aodi.id,
                        acquisition_transfer: {
                          vin: "vin123",
                          state: :transfering,
                          commercial_insurance: true,
                          current_plate_number: "abc",
                          total_transfer_fee_yuan: 20,
                          items: %w(
                            registration_license driving_license purchase_tax
                            new_owner_idcard used_vehicle_trade_invoice
                            compulsory_insurance
                          )
                        }

      acquisition_transfer = aodi.reload.acquisition_transfer

      expect(acquisition_transfer.state).to eq "transfering"

      data_completeness = {
        "finished" => 3,
        "total" => 4
      }
      expect(acquisition_transfer.commercial_insurance).to be_truthy
      expect(acquisition_transfer.data_completeness).to eq data_completeness
      expect(acquisition_transfer.compulsory_insurance).to eq true
      expect(acquisition_transfer.total_transfer_fee_yuan).to eq 20
      expect(aodi.reload.vin).to eq "vin123"
      expect(aodi.current_plate_number).to eq "abc"

      sale_transfer = aodi.reload.sale_transfer
      expect(sale_transfer.vin).to eq acquisition_transfer.vin
    end
  end
end
