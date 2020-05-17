require "rails_helper"

RSpec.describe TokenService::Payout do
  fixtures :all

  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }
  let(:order) { orders(:order_a) }
  let(:tianche) { companies(:tianche) }
  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }
  let(:zhangsan) { users(:zhangsan) }

  describe "#pay" do
    context "action_type 是维保查询" do
      before do
        TokenBill.destroy_all
        price_yuan = maintenance_record_uncheck.token_price
        company_token.update(balance: 100.23)
        service = TokenService::Payout.new(company_token)
        service.pay(action_type: :maintenance_query,
                    subject: maintenance_record_uncheck,
                    user: zhangsan,
                    amount: price_yuan)
      end

      it "给相应的token扣款" do
        expect(company_token.reload.balance).to eq 100.23 - 29
      end

      it "记录相应账单" do
        token_bill = TokenBill.last
        expect(TokenBill.count).to eq 1
        expect(token_bill.token_type).to eq "company"
      end

      it "记录是从哪个token相关信息" do
        expect(maintenance_record_uncheck.token_type).to eq "company"
        expect(maintenance_record_uncheck.token_id).to eq company_token.id
      end
    end
  end
end
