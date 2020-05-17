class AddOperatorIdToStockOutInventories < ActiveRecord::Migration
  def change
    add_column(:stock_out_inventories, :operator_id, :integer, index: true)
  end
end
