class AddIndexForCreatedAtForOperationRecords < ActiveRecord::Migration
  def change
    add_index :operation_records, :created_at
    add_index :operation_records, [:operation_record_type, :created_at]
  end
end
