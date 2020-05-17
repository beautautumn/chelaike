class AddHubIdToOldDriverRecord < ActiveRecord::Migration
  def change
    add_column :old_driver_records, :old_driver_record_hub_id, :integer, comment: "关联的hub"
    add_column :old_driver_records, :vin, :string, comment: "vin码"
  end
end
