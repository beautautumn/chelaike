class AddUserTypeToEasyLoanLoanBillHistories < ActiveRecord::Migration
  def change
    add_column :easy_loan_loan_bill_histories, :user_type, :string, comment: "用户类型"
    remove_foreign_key :easy_loan_loan_bill_histories, :user
  end
end
