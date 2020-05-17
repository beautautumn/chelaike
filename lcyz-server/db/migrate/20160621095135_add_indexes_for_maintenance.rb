class AddIndexesForMaintenance < ActiveRecord::Migration
  def change
    add_index :maintenance_record_hubs, :vin
    add_index :maintenance_record_hubs, :order_id
    add_index :maintenance_records, :vin
    add_index :maintenance_records, :car_id
  end
end
