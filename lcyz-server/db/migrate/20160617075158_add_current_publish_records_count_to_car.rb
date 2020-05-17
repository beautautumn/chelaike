class AddCurrentPublishRecordsCountToCar < ActiveRecord::Migration
  def migrate(dir)
    super

    if dir == :up
      query = <<-SQL
        UPDATE cars
        SET current_publish_records_count = (SELECT count(*) FROM car_publish_records
        WHERE car_id = cars.id)
      SQL

      Car.connection.execute(query.squish!)
    end
  end

  def up
    add_column :cars, :current_publish_records_count, :integer, default: 0, null: false
  end

  def down
    remove_column :cars, :current_publish_records_count
  end
end
