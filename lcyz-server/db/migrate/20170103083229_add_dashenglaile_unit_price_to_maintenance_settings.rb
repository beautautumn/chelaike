class AddDashenglaileUnitPriceToMaintenanceSettings < ActiveRecord::Migration
  def change
    add_column :maintenance_settings, :dashenglaile_unit_price, :decimal, precision: 8, scale: 2, default: 29
  end
end
