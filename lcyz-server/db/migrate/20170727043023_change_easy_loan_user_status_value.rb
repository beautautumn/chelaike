class ChangeEasyLoanUserStatusValue < ActiveRecord::Migration
  def change
    change_column_default :easy_loan_users, :status, true
  end
end
