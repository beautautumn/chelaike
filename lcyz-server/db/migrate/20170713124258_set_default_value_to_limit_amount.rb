class SetDefaultValueToLimitAmount < ActiveRecord::Migration
  def change
    change_column :easy_loan_accredited_records, :limit_amount_cents, :bigint, default: 0
    change_column :easy_loan_accredited_records, :in_use_amount_cents, :bigint, default: 0
  end
end
