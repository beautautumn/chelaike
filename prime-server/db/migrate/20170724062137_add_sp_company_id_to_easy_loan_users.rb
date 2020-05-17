class AddSpCompanyIdToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column :easy_loan_users, :easy_loan_sp_company_id, :integer, comment: "所属sp公司"
  end
end
