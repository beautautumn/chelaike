class AddBorrowedAmountCentsToEasyLoanLoanBills < ActiveRecord::Migration
  def change
    add_column :easy_loan_loan_bills, :estimate_borrow_amount_cents, :bigint, default: 0, comment: "预计申请借款金额"
    add_column :easy_loan_loan_bills, :borrowed_amount_cents, :bigint, default: 0, comment: "实际申请借款金额"
  end
end
