# == Schema Information
#
# Table name: easy_loan_loan_bill_histories # 借款单状态变更历史
#
#  id                     :integer          not null, primary key # 借款单状态变更历史
#  easy_loan_loan_bill_id :integer                                # 对应的借款单
#  user_id                :integer                                # 操作人
#  bill_state             :string                                 # 记录当前的状态
#  message                :string                                 # 记录时的状态对应的消息
#  note                   :string                                 # 对应的备注
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_type              :string                                 # 用户类型
#  amount_cents           :integer                                # 更改状态时记录相应的金额
#

require "rails_helper"

RSpec.describe EasyLoan::LoanBillHistory, type: :model do
end
