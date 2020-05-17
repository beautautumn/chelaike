class AddCustomerIdToStockOutInventory < ActiveRecord::Migration
  def change
    add_column :stock_out_inventories, :customer_id, :integer, comment: "客户ID"
  end
end
