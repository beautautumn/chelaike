class AddCarriedInterestCentsToStockOutInventories < ActiveRecord::Migration
  def change
    add_column :stock_out_inventories, :carried_interest_cents, :bigint, comment: "提成金额"
    add_column :dw_out_of_stock_facts, :carried_interest_cents, :bigint, default: 0, comment: "提成金额"
  end
end
