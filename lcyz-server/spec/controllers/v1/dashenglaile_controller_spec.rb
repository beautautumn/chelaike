require "rails_helper"

RSpec.describe V1::DashenglaileController do
  fixtures :users, :dashenglaile_records, :dashenglaile_record_hubs,
           :maintenance_settings, :cars, :companies, :tokens

  let(:dashenglaile_record_uncheck) { dashenglaile_records(:dashenglaile_record_uncheck) }
  let(:dashenglaile_record_hub_a) { dashenglaile_record_hubs(:dashenglaile_record_hub_a) }
  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }

  describe "GET /api/v1/dashenglaile/brands" do
    before do
      login_user(zhangsan)
    end

    it "response brand" do
      VCR.use_cassette("dashenglaile_buy_success", allow_playback_repeats: true) do
        auth_get :brands
        expect(response_json[:data][:list]).to be_a Array
      end
    end
  end

  describe "GET /api/v1/dashenglaile/notify" do
    context "success" do
      before do
        @success_params = ParamsBuilder.build(
          "dashenglaile/success",
          order_id: dashenglaile_record_hub_a.id,
          vin: dashenglaile_record_hub_a.vin
        ).deep_symbolize_keys!
      end
      it "process success" do
        post :notify, @success_params
        record = dashenglaile_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_truthy
        expect(record.result_images.sort).to eq\
          @success_params[:result_images].split(",").sort
      end

      it "create massege" do
        count = DashenglaileRecord
                .where(dashenglaile_record_hub_id: dashenglaile_record_hub_a.id).size
        expect do
          post :notify, @success_params
        end.to change { company_token.reload.balance }.by(0).and\
          change { OperationRecord.count }.by(count).and\
            change(MessageWorker.jobs, :size).by(count)
      end
    end

    context "reject" do
      before do
        DashenglaileRecord.update_all(state: "generating",
                                      token_type: :company,
                                      token_id: company_token.id)
        @reject_params = ParamsBuilder.build(
          "dashenglaile/reject",
          order_id: dashenglaile_record_hub_a.id,
          vin: dashenglaile_record_hub_a.vin
        ).deep_symbolize_keys!
      end

      it "process reject" do
        post :notify, @reject_params
        record = dashenglaile_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_falsey
      end

      it "process reject refund" do
        records = DashenglaileRecord.where(dashenglaile_record_hub_id: dashenglaile_record_hub_a.id)
        price = records.sum(:token_price)
        expect do
          post :notify, @reject_params
        end.to change { company_token.reload.balance }.by(price).and\
          change { OperationRecord.count }.by(records.size).and\
            change(MessageWorker.jobs, :size).by(records.size)
      end

      it "正常退回给支付用户" do
        records = DashenglaileRecord.where(dashenglaile_record_hub_id: dashenglaile_record_hub_a.id)
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
        DashenglaileRecord.update_all(state: "generating",
                                      token_type: :company,
                                      token_id: company_token.id)
        @no_record_params = ParamsBuilder.build(
          "dashenglaile/no_record",
          order_id: dashenglaile_record_hub_a.id,
          vin: dashenglaile_record_hub_a.vin
        ).deep_symbolize_keys!
      end

      it "process no_record" do
        post :notify, @no_record_params
        record = dashenglaile_record_hub_a.reload
        expect(response.body).to eq "success"
        expect(record.notify_success?).to be_falsey
      end

      it "process no_record refund" do
        records = DashenglaileRecord.where(dashenglaile_record_hub_id: dashenglaile_record_hub_a.id)
        DashenglaileRecord.update_all(state: "generating")
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
