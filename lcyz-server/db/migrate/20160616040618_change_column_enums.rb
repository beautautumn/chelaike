class ChangeColumnEnums < ActiveRecord::Migration
  def change
    change_column :maintenance_record_hubs, :origin, :string
    change_column :maintenance_records, :state, :string
  end
end
