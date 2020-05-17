class AddIndexsToStockOutInventories < ActiveRecord::Migration
  def change
    add_index :stock_out_inventories, [:car_id, :current]
    add_index :stock_out_inventories, [:car_id, :current, :stock_out_inventory_type], name: :stock_out_inventories_car_id_current_type
  end
end
