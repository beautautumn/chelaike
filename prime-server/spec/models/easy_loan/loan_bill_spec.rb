# == Schema Information
#
# Table name: easy_loan_loan_bills # 借款单
#
#  id                           :integer          not null, primary key # 借款单
#  company_id                   :integer                                # 借款公司
#  car_id                       :integer                                # 用哪辆车进行借款
#  sp_company_id                :integer                                # 通过哪家sp公司
#  funder_company_id            :integer                                # 提供资金公司
#  car_basic_info               :jsonb                                  # 冗余车辆基本信息
#  state                        :string                                 # 借款单当前状态
#  state_history                :jsonb                                  # 状态变更历史记录概要
#  apply_code                   :string                                 # 申请编号
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  estimate_borrow_amount_cents :integer          default(0)            # 预计申请借款金额
#  borrowed_amount_cents        :integer          default(0)            # 实际申请借款金额
#

require "rails_helper"

RSpec.describe EasyLoan::LoanBill, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }

  describe "设置状态历史" do
    it "sets state history" do
      loan_bill = EasyLoan::LoanBill.create!(
        company_id: tianche.id,
        car_id: aodi.id,
        funder_company_id: gmc.id,
        state: :borrow_applied
      )

      loan_bill.update!(state: :reviewed)

      expect(loan_bill.reload.state_history).to be_present
    end
  end

  describe "#after_save" do
  #   it "如果状态发生变化, 记录一条状态变更历史数据" do
  #     loan_bill = EasyLoan::LoanBill.create!(
  #       company_id: tianche.id,
  #       car_id: aodi.id,
  #       funder_company_id: gmc.id,
  #       state: :borrow_applied
  #     )

  #     loan_bill.update!(state: :reviewed)

  #     expect(loan_bill.loan_bill_histories.count).to eq 2
  #   end
  end
end
