class AddRcTokenToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :rc_token, :string, comment: "融云token"
  end
end
