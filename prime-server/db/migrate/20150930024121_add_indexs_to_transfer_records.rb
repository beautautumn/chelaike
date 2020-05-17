class AddIndexsToTransferRecords < ActiveRecord::Migration
  def change
    add_index :transfer_records, [:transfer_record_type, :state]
  end
end

