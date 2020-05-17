class AddNameToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :name, :string, comment: "车融易用户姓名"
  end
end
