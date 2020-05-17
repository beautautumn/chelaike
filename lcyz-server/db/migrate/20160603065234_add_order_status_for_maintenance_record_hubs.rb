class AddOrderStatusForMaintenanceRecordHubs < ActiveRecord::Migration
  def change
    add_column :maintenance_record_hubs, :order_status, :integer, comment: "维保查询结果状态"
    add_column :maintenance_record_hubs, :order_message, :string, comment: "维保查询结果"
  end
end
