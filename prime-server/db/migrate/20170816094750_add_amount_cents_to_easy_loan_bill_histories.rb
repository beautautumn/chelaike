class AddAmountCentsToEasyLoanBillHistories < ActiveRecord::Migration
  def change
    add_column :easy_loan_loan_bill_histories, :amount_cents, :bigint, comment: "更改状态时记录相应的金额"
  end
end
