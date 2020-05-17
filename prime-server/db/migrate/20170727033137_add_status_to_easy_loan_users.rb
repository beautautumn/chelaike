class AddStatusToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :status, :boolean, comment: "员工状态"
    add_reference :easy_loan_users, :easy_loan_authority_role, index: true, foreign_key: true, comment: "角色关联"
  end
end
