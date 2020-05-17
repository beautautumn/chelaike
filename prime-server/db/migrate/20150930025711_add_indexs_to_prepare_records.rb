class AddIndexsToPrepareRecords < ActiveRecord::Migration
  def change
    add_index :prepare_records, :preparer_id
    add_index :prepare_records, :state
  end
end
