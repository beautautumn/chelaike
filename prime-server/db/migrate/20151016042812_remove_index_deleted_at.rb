class RemoveIndexDeletedAt < ActiveRecord::Migration
  def change
    remove_index :channels, :deleted_at
    remove_index :cooperation_companies, :deleted_at
    remove_index :insurance_companies, :deleted_at
    remove_index :mortgage_companies, :deleted_at
    remove_index :warranties, :deleted_at
  end
end
