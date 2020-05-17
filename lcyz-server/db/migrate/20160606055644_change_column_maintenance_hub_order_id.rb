class ChangeColumnMaintenanceHubOrderId < ActiveRecord::Migration
  def change
    change_column :maintenance_record_hubs, :order_id, :string
  end
end
