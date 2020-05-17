require "rails_helper"

RSpec.describe TokenService::Income do
  fixtures :all

  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }
  let(:order) { orders(:order_a) }
  let(:tianche) { companies(:tianche) }
  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }

  describe "#charge" do
    context "给公司充值" do
      before do
        order.update(token_type: :company,
                     status: "charge",
                     action: "token",
                     amount_yuan: 10
                    )
        @service = TokenService::Income.new(company_token)
      end

      it "更新相应order状态为success" do
        @service.charge(order)
        expect(order.reload.status).to eq "success"
      end

      it "增加相应token里的balance" do
        @service.charge(order)
        expect(company_token.reload.balance).to eq 110.23
        expect(Token.find_by(company_id: tianche).balance).to eq 110.23
      end

      it "生成操作记录" do
        @service.charge(order)
        record = OperationRecord.last
        expect(record.operation_record_type).to eq "token_recharge"
      end

      it "生成账单" do
        expect do
          @service.charge(order)
        end.to change { TokenBill.count }.by 1
      end
    end
    context "给个人充值" do
      before do
        order.update(token_type: :user,
                     status: "charge",
                     action: "token",
                     amount_yuan: 10)
      end
    end
  end

  describe "#refund" do
    before do
      maintenance_record_uncheck.update!(state: :generating)
    end

    it "退回给相应的token" do
      service = TokenService::Income.new(user_token)
      service.refund(maintenance_record_uncheck, 29)
      expect(user_token.reload.balance).to eq 12.34 + 29
    end

    it "生成账单" do
      service = TokenService::Income.new(user_token)
      expect do
        service.refund(maintenance_record_uncheck, 29)
      end.to change { TokenBill.count }.by 1
    end

    it "更新相应查询记录的状态为失败" do
      service = TokenService::Income.new(user_token)
      service.refund(maintenance_record_uncheck, 29)
      expect(maintenance_record_uncheck.reload.state).to eq "generating_fail"
    end
  end
end
