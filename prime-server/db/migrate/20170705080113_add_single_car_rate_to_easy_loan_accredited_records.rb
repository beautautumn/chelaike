class AddSingleCarRateToEasyLoanAccreditedRecords < ActiveRecord::Migration
  def change
    add_column :easy_loan_accredited_records, :single_car_rate, :decimal, comment: "单车借款比例"
    add_column :easy_loan_accredited_records, :sp_company_id, :integer, comment: "对应的sp公司"
  end
end
