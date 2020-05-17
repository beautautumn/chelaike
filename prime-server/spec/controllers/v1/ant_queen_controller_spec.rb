require "rails_helper"

RSpec.describe V1::AntQueenController do
  fixtures :users, :ant_queen_records, :ant_queen_record_hubs,
           :maintenance_settings, :cars, :companies, :tokens

  let(:ant_queen_record_uncheck) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:ant_queen_record_hub_a) { ant_queen_record_hubs(:ant_queen_record_hub_a) }
  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }

  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }

  describe "GET /api/v1/ant_queen/brands" do
    before do
      login_user(zhangsan)
    end

    it "response brand" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        auth_get :brands
        expect(response_json[:data][:list]).to be_a Array
      end
    end

    it "response brand with chosen" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        auth_get :brands, query: { car_id: aodi.id }
        expect(response_json[:data][:chosen]).to be_present
      end
    end
  end

  describe "GET /api/v1/ant_queen/notify" do
    context "new success" do
      before do
        @new_success_params = ParamsBuilder.build(
          "ant_queen/new_success",
          order_id: ant_queen_record_hub_a.id,
          vin: ant_queen_record_hub_a.vin
        ).deep_symbolize_keys!
      end
      it "process new success" do
        post :notify, @new_success_params
        record = ant_queen_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_truthy
        expect(record.result_images.sort).to eq\
          @new_success_params[:result_images].split(",").sort
        expect(record.car_info.to_json).to eq\
          @new_success_params[:car_info]
        expect(record.car_status.to_json).to eq\
          @new_success_params[:car_status]
      end

      it "create massege" do
        count = AntQueenRecord
                .where(ant_queen_record_hub_id: ant_queen_record_hub_a.id).size
        expect do
          post :notify, @new_success_params
        end.to change { company_token.reload.balance }.by(0).and\
          change { OperationRecord.count }.by(count).and\
            change(MessageWorker.jobs, :size).by(count)
      end
    end

    context "success" do
      before do
        @success_params = ParamsBuilder.build(
          "ant_queen/success",
          order_id: ant_queen_record_hub_a.id,
          vin: ant_queen_record_hub_a.vin
        ).deep_symbolize_keys!
      end
      it "process success" do
        post :notify, @success_params
        record = ant_queen_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_truthy
        expect(record.result_images.sort).to eq\
          @success_params[:result_images].split(",").sort
      end

      it "create massege" do
        count = AntQueenRecord
                .where(ant_queen_record_hub_id: ant_queen_record_hub_a.id).size
        expect do
          post :notify, @success_params
        end.to change { company_token.reload.balance }.by(0).and\
          change { OperationRecord.count }.by(count).and\
            change(MessageWorker.jobs, :size).by(count)
      end
    end

    context "reject" do
      before do
        AntQueenRecord.update_all(state: "generating",
                                  token_type: :company,
                                  token_id: company_token.id)

        @reject_params = ParamsBuilder.build(
          "ant_queen/reject",
          order_id: ant_queen_record_hub_a.id,
          vin: ant_queen_record_hub_a.vin
        ).deep_symbolize_keys!
      end

      it "process reject" do
        post :notify, @reject_params
        record = ant_queen_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_falsey
      end

      it "process reject refund" do
        records = AntQueenRecord.where(ant_queen_record_hub_id: ant_queen_record_hub_a.id)
        price = records.sum(:token_price)
        expect do
          post :notify, @reject_params
        end.to change { company_token.reload.balance }.by(price).and\
          change { OperationRecord.count }.by(records.size).and\
            change(MessageWorker.jobs, :size).by(records.size)
      end

      it "正常退回给支付用户" do
        records = AntQueenRecord.where(ant_queen_record_hub_id: ant_queen_record_hub_a.id)
        record = records.first
        record.update!(token_type: :user, token_id: user_token.id)
        price = record.token_price

        expect do
          post :notify, @reject_params
        end.to change { user_token.reload.balance }.by(price)
      end
    end

    context "no_record" do
      before do
        AntQueenRecord.update_all(state: "generating",
                                  token_type: :company,
                                  token_id: company_token.id)

        @no_record_params = ParamsBuilder.build(
          "ant_queen/no_record",
          order_id: ant_queen_record_hub_a.id,
          vin: ant_queen_record_hub_a.vin
        ).deep_symbolize_keys!
      end

      it "process no_record" do
        post :notify, @no_record_params
        record = ant_queen_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_falsey
      end

      it "process no_record refund" do
        records = AntQueenRecord.where(ant_queen_record_hub_id: ant_queen_record_hub_a.id)
        AntQueenRecord.update_all(state: "generating")
        price = records.sum(:token_price)
        expect do
          post :notify, @no_record_params
        end.to change { company_token.reload.balance }.by(price).and\
          change { OperationRecord.count }.by(records.size).and\
            change(MessageWorker.jobs, :size).by(records.size)
      end
    end
  end
end
