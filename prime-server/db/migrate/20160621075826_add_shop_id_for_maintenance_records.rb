class AddShopIdForMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :shop_id, :integer
  end
end
