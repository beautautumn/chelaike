class RemoveEnvironmentMarkToTransferRecord < ActiveRecord::Migration
  def change
    remove_column :transfer_records, :environment_mark
  end
end
