class AddCoverUrlToCars < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL.squish!
      UPDATE cars
      SET (cover_url, alliance_cover_url) = (
        (
          SELECT images.url FROM images
          WHERE images.imageable_id = cars.id AND imageable_type = 'Car' AND is_cover = 't'
            AND image_style is NUll LIMIT 1
        ), (
          SELECT images.url FROM images
          WHERE images.imageable_id = cars.id AND imageable_type = 'Car' AND is_cover = 't'
            AND image_style = 'alliance' LIMIT 1
        )
      )
    SQL

    Car.connection.execute(query)
  end

  def change
    add_column :cars, :cover_url, :string, index: true, comment: "车辆封面图"

    add_column :cars, :alliance_cover_url, :string, index: true, comment: "联盟封面图"
  end
end
