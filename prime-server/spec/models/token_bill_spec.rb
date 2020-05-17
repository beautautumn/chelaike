# == Schema Information
#
# Table name: token_bills # 车币账单
#
#  id                 :integer          not null, primary key # 车币账单
#  state              :string                                 # 车币支付状态
#  action_type        :string                                 # 事件类型
#  payment_type       :string                                 # 收支类型
#  amount             :integer                                # 金额
#  operator_id        :integer                                # 事件的操作人
#  action_abstraction :jsonb                                  # 事件的概要描述
#  owner_id           :integer                                # Token的拥有者，可能为公司或个人
#  token_type         :string                                 # token类型
#  company_id         :integer                                # 操作人所属公司
#  shop_id            :integer                                # 操作人所属店铺
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require "rails_helper"

RSpec.describe TokenBill, type: :model do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:user_token_bill) { token_bills(:user_token_bill) }
  let(:company_token_bill) { token_bills(:company_token_bill) }

  before do
    user_token_bill.update!(owner_id: zhangsan.id,
                            company_id: tianche.id)
    company_token_bill.update!(owner_id: tianche.id)
  end

  describe ".get_bills" do
    context "参数是user类型" do
      it "得到这个用户的所有账单" do
        bills = TokenBill.get_bills(zhangsan)
        bill = bills.first
        expect(bills.count).to eq 1
        expect(bill.token_type).to eq "user"
        expect(bill.owner_id).to eq zhangsan.id
      end
    end

    context "参数是company类型" do
      it "得到这个company的所有账单" do
        bills = TokenBill.get_bills(tianche)
        bill = bills.first
        expect(bills.count).to eq 1
        expect(bill.token_type).to eq "company"
        expect(bill.owner_id).to eq tianche.id
      end
    end
  end

  describe "#date_str" do
    it "得到日期的文字形式，今天" do
      user_token_bill.update!(created_at: Time.zone.now)
      expect(user_token_bill.date_str).to eq "今天"
    end

    it "得到文字形式，周二" do
      user_token_bill.update!(created_at: Date.new(2016, 12, 6))
      expect(user_token_bill.date_str).to eq "周二"
    end
  end
end
