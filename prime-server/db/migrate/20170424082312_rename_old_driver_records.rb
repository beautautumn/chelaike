class RenameOldDriverRecords < ActiveRecord::Migration
  def change
    remove_column :old_driver_records, "支付状态"
    remove_column :old_driver_records, "查询类型，new,refetch"
  end
end
