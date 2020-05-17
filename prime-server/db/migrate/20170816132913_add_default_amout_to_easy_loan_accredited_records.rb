class AddDefaultAmoutToEasyLoanAccreditedRecords < ActiveRecord::Migration
  def change
    change_column_default :easy_loan_accredited_records, :in_use_amount_cents, 0
  end
end
