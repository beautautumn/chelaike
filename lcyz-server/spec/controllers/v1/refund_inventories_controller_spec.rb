require "rails_helper"

RSpec.describe V1::RefundInventoriesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    give_authority(zhangsan, "出库车辆回库")
    login_user(zhangsan)
  end

  describe "POST /api/v1/cars/:car_id/refund_inventory" do
    after do
      expect(aodi.reload.state).to eq "in_hall"
      expect(aodi.refund_inventory).to be_present
      expect(aodi.stock_out_inventory).to be_nil
      expect(aodi.stock_out_at).to be_nil
    end

    context "when refund_inventory_type is sold" do
      before do
        aodi.update_columns(state: :sold)
      end
      it "creates a refund_inventory" do
        auth_post :create, car_id: aodi.id,
                           refund_inventory: {
                             refunded_at: "2015-07-20",
                             refund_price_wan: 10,
                             note: "有问题"
                           }

        expect(aodi.refund_inventory.refund_price_wan).to eq 10
        expect(aodi.refund_inventory.refund_inventory_type).to eq "sold"
      end
    end

    context "when refund_inventory_type is driven_back" do
      before do
        aodi.update_columns(state: :driven_back)

        @request_lambda = lambda do
          auth_post :create, car_id: aodi.id,
                             refund_inventory: {
                               refunded_at: "2015-07-20",
                               note: "车主开回来了"
                             }
        end
      end
      it "creates a refund_inventory" do
        @request_lambda.call

        expect(aodi.refund_inventory.refund_inventory_type).to eq "driven_back"
      end

      it_should_behave_like "operation_record created" do
        let(:request_query) { @request_lambda.call }
      end
    end

    context "when refund_inventory_type is acquisition_refunded" do
      before do
        aodi.update_columns(state: :acquisition_refunded)

        @request_lambda = lambda do
          auth_post :create, car_id: aodi.id,
                             refund_inventory: {
                               refunded_at: "2015-07-20",
                               acquisition_price_wan: 18,
                               note: "这车又回来了"
                             }
        end
      end

      it "creates a refund_inventory and update acquisition_price" do
        @request_lambda.call

        expect(aodi.reload.acquisition_price_wan).to eq 18
        expect(aodi.refund_inventory.refund_inventory_type).to eq "acquisition_refunded"
      end

      it_should_behave_like "operation_record created" do
        let(:request_query) { @request_lambda.call }
      end
    end
  end
end
