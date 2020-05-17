class CreateMaintenanceSettings < ActiveRecord::Migration
  def change
    create_table :maintenance_settings do |t|
      t.decimal :chejianding_unit_price, precision: 8, scale: 2, default: 17
      t.decimal :ant_queen_unit_price, precision: 8, scale: 2, default: 29
    end
  end
end
