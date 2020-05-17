class AddAbstractItemsToMaintenanceRecordHub < ActiveRecord::Migration
  def change
    add_column :maintenance_record_hubs, :abstract_items, :jsonb, comment: "报告概要项目"
  end
end
