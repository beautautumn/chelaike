require "rails_helper"

RSpec.describe V1::StockOutInventoriesController do
  fixtures :all
  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:individual) { channels(:individual) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:cmb_china) { mortgage_companies(:cmb_china) }
  let(:nobita) { customers(:nobita) }
  let(:gian) { customers(:gian) }
  let(:shizuka) { customers(:shizuka) }

  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:pixar) { shops(:pixar) }
  let(:a4_old) { cars(:a4) }
  let(:a4) { cars(:a4_copied) }

  before do
    give_authority(zhangsan, "在库车辆出库", "销售成交信息查看", "保险信息查看")
    ExpirationSetting.init(tianche)
    aodi.update_columns(reserved_at: Time.zone.now, reserved: true)
    login_user(zhangsan)
    allow_any_instance_of(Publisher::Che168Service).to receive(:execute).and_return("")
  end

  describe "POST /api/v1/cars/:car_id/stock_out_inventories" do
    context "when stock_out_inventory_type is sale" do
      before do
        @parameters = ParamsBuilder.build(
          :stock_out_inventories,
          zhangsan: zhangsan,
          individual: individual,
          pingan: pingan,
          cmb_china: cmb_china
        ).deep_symbolize_keys
      end

      after do
        expect(aodi.reload.reserved_at).to be_present
        expect(aodi.reserved).to be_falsy
      end

      context "when payment_type is cash" do
        before do
          travel_to Time.zone.now
          aodi.stock_out_inventories.to_histories

          @request_lambda = lambda do
            auth_post :create,
                      car_id: aodi.id,
                      stock_out_inventory: @parameters.fetch(:cash).merge(sales_type: :self_retail)
            aodi.reload
          end
        end

        it "creates a record" do
          expect do
            @request_lambda.call
          end.to change { aodi.stock_out_inventories.count }.by(1)
        end

        it "changes attributes" do
          @request_lambda.call

          expect(aodi.state).to eq "sold"
          expect(aodi.sale_record.payment_type).to eq "cash"
          expect(aodi.stock_out_inventory.insurance_company_id).to eq pingan.id
          expect(aodi.stock_out_inventory.carried_interest_wan).to eq 1
          expect(aodi.stock_out_inventory.invoice_fee_yuan).to eq 100
        end

        it "sets stock_out_at" do
          @request_lambda.call

          expect(aodi.stock_out_at).to eq Time.zone.parse("2015-04-20")
        end

        it_should_behave_like "operation_record created" do
          let(:request_query) { @request_lambda.call }
        end
      end

      context "when payment_type is mortgage" do
        it "changes state for car" do
          auth_post :create,
                    car_id: aodi.id,
                    stock_out_inventory: @parameters.fetch(:mortgage)
          aodi.reload

          expect(aodi.state).to eq "sold"
          expect(aodi.sale_record.payment_type).to eq "mortgage"
          expect(aodi.stock_out_at).to eq Time.zone.parse("2015-04-20")
        end
      end
    end

    context "when stock_out_inventory is acquisition_refund" do
      before do
        @request_lambda = lambda do
          auth_post :create,
                    car_id: aodi.id,
                    stock_out_inventory: {
                      stock_out_inventory_type: "acquisition_refunded",
                      refunded_at: "2015-6-12",
                      refund_price_wan: 2
                    }
        end
      end

      after do
        expect(aodi.reload.reserved_at).to be_present
        expect(aodi.reserved).to be_falsy
        # expect(aodi.stock_out_at).to eq Time.zone.parse("2015-01-01")
      end

      it "creates a refund inventory" do
        @request_lambda.call

        expect(aodi.acquisition_refund_record.refund_price_wan).to eq 2
      end

      it_should_behave_like "operation_record created" do
        let(:request_query) { @request_lambda.call }
      end
    end

    context "when stock_out_inventory is driven_back" do
      before do
        @request_lambda = lambda do
          auth_post :create,
                    car_id: aodi.id,
                    stock_out_inventory: {
                      stock_out_inventory_type: "driven_back",
                      driven_back_at: "2015-04-23"
                    }
        end
      end

      it "creates a driven_back record" do
        @request_lambda.call

        expect(aodi.driven_back_record.driven_back_at)
          .to eq(Time.zone.parse("2015-04-23"))
        # expect(aodi.stock_out_at).to eq Time.zone.parse("2015-01-01")
      end

      it_should_behave_like "operation_record created" do
        let(:request_query) { @request_lambda.call }
      end
    end

    context "联盟出库" do
      before do
        @parameters = ParamsBuilder.build(
          "stock_out_inventories/alliance",
          nolan: nolan,
          avengers: avengers,
          tianche: tianche,
          pixar: pixar
        ).deep_symbolize_keys
        @request_lambda = lambda do
          auth_post :create,
                    car_id: a4.id,
                    stock_out_inventory: @parameters.fetch(:alliance)
          a4.reload
        end
      end

      it "修改原车状态" do
        @request_lambda.call
        expect(a4.state).to eq "alliance_stocked_out"
        expect(a4.stock_out_at).to eq Time.zone.today
        expect(a4.closing_cost_wan).to eq 18
      end

      it "复制新车" do
        expect { @request_lambda.call }.to change { tianche.cars.count }.by(1)
      end

      it "建立联盟出库记录" do
        expect { @request_lambda.call }.to change { OperationRecord.count }.by(2)
        expect(a4.alliance_stock_out_inventories).to be_present
      end
    end

    context "联盟退车" do
      before do
        @request_lambda = lambda do
          auth_post :create,
                    car_id: a4.id,
                    stock_out_inventory: {
                      stock_out_inventory_type: "alliance_refunded",
                      refunded_price_wan: 18,
                      refunded_at: Time.zone.today
                    }
          a4.reload
        end
      end

      it "新车退库" do
        @request_lambda.call
        expect(a4.state).to eq "alliance_refunded"
      end

      it "原车回库" do
        @request_lambda.call
        expect(a4_old.state).to eq "in_hall"
      end

      it "更新出库记录" do
        expect { @request_lambda.call }.to change { OperationRecord.count }.by(2)
        expect(a4.alliance_stock_out_inventory).to be_blank
      end
    end
  end

  describe "PUT /api/v1/cars/:car_id/stock_out_inventories" do
    before do
      @stock_out_inventory = ParamsBuilder.build(
        :stock_out_inventories,
        zhangsan: zhangsan,
        individual: individual,
        pingan: pingan,
        cmb_china: cmb_china
      ).deep_symbolize_keys
    end

    after do
      # expect(aodi.stock_out_at).to eq Time.zone.parse("2015-01-01")
    end

    it "syncs sale transfer_record" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory
      expect(aodi.sale_transfer.total_transfer_fee_yuan).to eq 400
    end

    it "更新销售出库清单" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      validation_fields = [
        :completed_at, :seller_id, :customer_channel_id, :closing_cost_wan, :sales_type,
        :payment_type, :deposit_wan, :remaining_money_wan, :transfer_fee_yuan,
        :total_transfer_fee_yuan, :commission_yuan, :other_fee_yuan,
        :customer_location_province, :customer_location_city, :customer_location_address,
        :customer_name, :customer_phone, :customer_idcard,
        :proxy_insurance, :note
      ]
      result = response_json[:data].slice(*validation_fields)
      result[:completed_at] = result[:completed_at].to_date

      result.delete(:customer_id)
      stock_out_inventory.delete(:stock_out_inventory_type)

      expect(aodi.stock_out_inventory.customer).to be_present
      expect(aodi.reload.state).to eq :sold
      expect(aodi.stock_out_inventory.closing_cost_wan).to eq 20
      expect(result).to eq stock_out_inventory
    end

    it "关联没有意向的客户，并更新销售出库清单" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)
      stock_out_inventory[:customer_phone] = nobita.phone

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      validation_fields = [
        :completed_at, :seller_id, :customer_channel_id, :closing_cost_wan, :sales_type,
        :payment_type, :deposit_wan, :remaining_money_wan, :transfer_fee_yuan,
        :commission_yuan, :other_fee_yuan,
        :customer_location_province, :customer_location_city, :customer_location_address,
        :customer_name, :customer_phone, :customer_idcard,
        :proxy_insurance, :note
      ]
      result = response_json[:data].slice(*validation_fields)
      result[:completed_at] = result[:completed_at].to_date

      result.delete(:customer_id)
      stock_out_inventory.delete(:stock_out_inventory_type)

      expect(aodi.stock_out_inventory.customer).to be_present
      expect(Intention.find_by(customer_id: aodi.stock_out_inventory.customer.id)
             .state).to eq "completed"
    end

    it "关联有已完成意向的客户，并更新销售出库清单" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)
      stock_out_inventory[:customer_phone] = gian.phone

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      validation_fields = [
        :completed_at, :seller_id, :customer_channel_id, :closing_cost_wan, :sales_type,
        :payment_type, :deposit_wan, :remaining_money_wan, :transfer_fee_yuan,
        :commission_yuan, :other_fee_yuan,
        :customer_location_province, :customer_location_city, :customer_location_address,
        :customer_name, :customer_phone, :customer_idcard,
        :proxy_insurance, :note
      ]
      result = response_json[:data].slice(*validation_fields)
      result[:completed_at] = result[:completed_at].to_date

      result.delete(:customer_id)
      stock_out_inventory.delete(:stock_out_inventory_type)

      expect(aodi.stock_out_inventory.customer).to be_present
      expect(Intention.find_by(customer_id: aodi.stock_out_inventory.customer.id)
             .state).not_to eq "completed"
    end

    it "关联有未完成意向的客户，并更新销售出库清单" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)
      stock_out_inventory[:customer_phone] = shizuka.phone

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      validation_fields = [
        :completed_at, :seller_id, :customer_channel_id, :closing_cost_wan, :sales_type,
        :payment_type, :deposit_wan, :remaining_money_wan, :transfer_fee_yuan,
        :commission_yuan, :other_fee_yuan,
        :customer_location_province, :customer_location_city, :customer_location_address,
        :customer_name, :customer_phone, :customer_idcard,
        :proxy_insurance, :note
      ]
      result = response_json[:data].slice(*validation_fields)
      result[:completed_at] = result[:completed_at].to_date

      result.delete(:customer_id)
      stock_out_inventory.delete(:stock_out_inventory_type)

      expect(aodi.stock_out_inventory.customer).to be_present

      intention = Intention.find_by(customer_id: aodi.stock_out_inventory.customer.id)

      expect(intention.after_sale_assignee_id).to eq intention.assignee_id
      expect(intention.state).to eq "completed"
    end

    it "without stock_out_inventory_type" do
      stock_out_inventory = @stock_out_inventory.fetch(:sold)
                                                .except!(:stock_out_inventory_type)

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      expect(aodi.reload.stock_out_inventory.changed?).to be_falsy
    end

    it "收购退车" do
      stock_out_inventory = @stock_out_inventory.fetch(:acquisition_refunded)

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory
      result = {
        refunded_at: aodi.reload.stock_out_inventory.refunded_at,
        refund_price_wan: aodi.stock_out_inventory.refund_price_wan
      }

      stock_out_inventory.delete(:stock_out_inventory_type)
      expect(aodi.state).to eq :acquisition_refunded
      expect(result).to eq stock_out_inventory
    end

    it "车主开回" do
      stock_out_inventory = ParamsBuilder.build(
        :stock_out_inventories,
        zhangsan: zhangsan,
        individual: individual,
        pingan: pingan,
        cmb_china: cmb_china
      ).deep_symbolize_keys.fetch(:driven_back)

      auth_put :update, car_id: aodi.id, stock_out_inventory: stock_out_inventory

      result = {
        driven_back_at: aodi.reload.stock_out_inventory.driven_back_at
      }

      stock_out_inventory.delete(:stock_out_inventory_type)
      expect(aodi.state).to eq :driven_back
      expect(result).to eq stock_out_inventory
    end
  end

  describe "GET /api/v1/cars/:car_id/stock_out_inventory" do
    it "获取当前出库清单" do
      auth_get :show, car_id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.stock_out_inventory.id
    end

    it "包含发票费用" do
      auth_get :show, car_id: aodi.id
      expect(response_json[:data][:invoice_fee_yuan])
        .to eq aodi.stock_out_inventory.invoice_fee_yuan
    end
  end
end
