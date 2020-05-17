class ChangeAmountCentsToAmountForTokenBills < ActiveRecord::Migration
  def change
    rename_column :token_bills, :amount_cents, :amount
  end
end
