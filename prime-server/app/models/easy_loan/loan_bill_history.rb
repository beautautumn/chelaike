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

class EasyLoan::LoanBillHistory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :loan_bill, class_name: "EasyLoan::LoanBill"
  belongs_to :user, polymorphic: true
  # validations ...............................................................
  # callbacks .................................................................
  before_create :set_message
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :amount
  # class methods .............................................................
  # public instance methods ...................................................

  def state_text
    EasyLoan::LoanBill::STATE_TEXT.fetch(bill_state.to_sym, "无状态")
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_message
    self.message = case bill_state.to_s
                   when "borrow_applied"
                     "预计可借#{amount_wan}万" if amount_wan
                   when "reviewed"
                     "核定放款#{amount_wan}万" if amount_wan
                   else
                     "#{amount_wan}万" if amount_wan
                   end
  end
end
