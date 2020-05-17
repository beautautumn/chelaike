class AddBackImagesCountToCars < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL
      UPDATE cars
      SET images_count = (SELECT count(*) FROM images
      WHERE imageable_type='Car' AND imageable_id = cars.id)
    SQL

    Car.connection.execute(query.squish!)
  end

  def change
    unless column_exists?(:cars, :images_count)
      add_column :cars, :images_count, :integer, default: 0, index: true, comment: "图片数量"
    end
  end
end
