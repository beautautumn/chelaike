class AddAuthoritiesToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :authorities, :text, array: true, default: [], comment: "权限清单"
  end
end
