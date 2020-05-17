class AddBeforeUpdateHubIdToOldDriverRecords < ActiveRecord::Migration
  def change
    add_column :old_driver_records, :before_update_hub_id, :integer, comment: "更新前的报告id"
  end
end
