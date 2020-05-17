require "rails_helper"

RSpec.describe V1::ChaDoctorController do
  fixtures :users, :ant_queen_records, :ant_queen_record_hubs, :cars,
           :maintenance_settings, :companies, :tokens, :platform_brands

  let(:vin) { "LFPH3ACC7A1A61382" }
  let(:licenseplate) { "苏EX009K" }
  let(:order_id) { "e683890506454015a59533bf31f59773" }

  let(:zhangsan) { users(:zhangsan) }
  let(:ant_queen_record_uncheck) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:records) { AntQueenRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }
  let(:user_token) { tokens(:user_token) }
  let(:company_token) { tokens(:company_token) }

  before do
    travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
    allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

    login_user(zhangsan)
    Token.create(company_id: zhangsan.company_id, balance: 200000)

    price = ChaDoctorRecord.unit_price

    @hub = ChaDoctorRecordHub.create(vin: vin, order_id: order_id, notify_status: nil)
    @record = ChaDoctorRecord.create!(vin: vin, state: :generating,
                                      cha_doctor_record_hub_id: @hub.id,
                                      last_cha_doctor_record_hub_id: @hub.id,
                                      token_price: price,
                                      action_type: :new,
                                      company_id: zhangsan.company_id,
                                      payment_state: :paid
                                     )
  end

  describe "POST notify" do
    context "通知成功" do
      it "更新报告及记录状态" do
        VCR.use_cassette("cha_doctors/get_report_json") do
          post :notify, result: "1", orderid: order_id, message: "已出报告"
          expect(@hub.reload.notify_status).to eq "1"
          expect(@record.reload.state).to eq "unchecked"
          operation_record = OperationRecord.last
          expect(operation_record.targetable).to eq @record
        end
      end

      it "生成操作记录，发送消息给相应用户"
    end

    context "通知失败" do
      before do
        ChaDoctorRecord.update_all(token_type: :user, token_id: user_token.id)
      end

      it "更新报告及记录状态" do
        post :notify, result: "2", orderid: order_id, message: "生成报告失败"
        @hub.reload
        expect(@hub.notify_status).to eq "2"
        expect(@hub.notify_state).to eq "failed"
        expect(@record.reload.state).to eq "generating_fail"
      end

      it "给报告对应的用户退款" do
        expect do
          post :notify, result: "2", orderid: order_id, message: "生成报告失败"
        end.to change { user_token.reload.balance }.by(ChaDoctorRecord.unit_price)
      end

      it "报告对应的查询记录的支付状态改为refunded" do
        post :notify, result: "2", orderid: order_id, message: "生成报告失败"
        expect(@record.reload.payment_state).to eq "refunded"
      end

      it "如果记录支付状态为refunded,不会重复退款" do
        @record.update!(payment_state: :refunded)
        company_token = Token.find_by(company_id: zhangsan.company_id)
        expect do
          post :notify, result: "2", orderid: order_id, message: "生成报告失败"
        end.to change { company_token.reload.balance }.by(0)
      end

      it "生成操作记录，并发送消息" do
        post :notify, result: "2", orderid: order_id, message: "生成报告失败"
        operation_record = OperationRecord.last
        expect(operation_record.targetable).to eq @record
        expect(operation_record.operation_record_type).to eq "maintenance_fetch_fail"
      end
    end
  end
end
