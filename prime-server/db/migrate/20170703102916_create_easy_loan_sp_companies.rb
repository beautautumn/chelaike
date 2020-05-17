class CreateEasyLoanSpCompanies < ActiveRecord::Migration
  def change
    create_table :easy_loan_sp_companies, comment: "借款的sp公司" do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
