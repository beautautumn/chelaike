class RemoveImagesCountFromMaintenanceRecords < ActiveRecord::Migration
  def change
    remove_column :maintenance_records, :images_count
  end
end
