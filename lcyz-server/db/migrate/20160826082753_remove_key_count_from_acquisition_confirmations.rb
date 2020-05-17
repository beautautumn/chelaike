class RemoveKeyCountFromAcquisitionConfirmations < ActiveRecord::Migration
  def change
    remove_column :acquisition_confirmations, :key_count, :integer
  end
end
