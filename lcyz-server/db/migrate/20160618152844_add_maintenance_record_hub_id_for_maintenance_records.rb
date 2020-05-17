class AddMaintenanceRecordHubIdForMaintenanceRecords < ActiveRecord::Migration
  def change
    add_column :maintenance_records, :last_maintenance_record_hub_id, :integer, commont: "用来记录更新前的id"
  end
end
