class AddBackImagesCountToTransferRecords < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL
      UPDATE transfer_records
      SET images_count = (SELECT count(*) FROM images
      WHERE imageable_type='TransferRecord' AND imageable_id = transfer_records.id)
    SQL

    Car.connection.execute(query.squish!)
  end

  def change
    unless column_exists?(:transfer_records, :images_count)
      add_column :transfer_records, :images_count, :integer, default: 0, index: true, comment: "图片数量"
    end
  end
end
