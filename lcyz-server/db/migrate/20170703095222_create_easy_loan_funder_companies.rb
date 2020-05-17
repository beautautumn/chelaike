class CreateEasyLoanFunderCompanies < ActiveRecord::Migration
  def change
    create_table :easy_loan_funder_companies, commnet: "资金提供方" do |t|
      t.string :name, commnet: "资金方名"

      t.timestamps null: false
    end
  end
end
