class AddEngineForMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :engine, :string, comment: "发动机"
    add_column :maintenance_records, :license_plate, :string, comment: "车牌"
  end
end
