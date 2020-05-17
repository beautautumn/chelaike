class AddNotifyInfoForMaintenanceRecordHubs < ActiveRecord::Migration
  def change
    add_column :maintenance_record_hubs, :notify_status, :integer, comment: "异步回调结果状态"
    add_column :maintenance_record_hubs, :notify_message, :string, comment: "异步回调结果消息"
  end
end
