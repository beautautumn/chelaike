class AddBackImagesCountToMaintenanceRecords < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL
      UPDATE maintenance_records
      SET images_count = (SELECT count(*) FROM images
      WHERE imageable_type='MaintenanceRecord' AND imageable_id = maintenance_records.id)
    SQL

    Car.connection.execute(query.squish!)
  end

  def change
    unless column_exists?(:maintenance_records, :images_count)
      add_column :maintenance_records, :images_count, :integer, default: 0, index: true, comment: "图片数量"
    end
  end
end
