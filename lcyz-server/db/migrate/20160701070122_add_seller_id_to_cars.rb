class AddSellerIdToCars < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL.squish!
      UPDATE cars
      SET seller_id = (
        SELECT stock_out_inventories.seller_id FROM stock_out_inventories
        WHERE stock_out_inventories.car_id = cars.id AND stock_out_inventories.current = 't'
        ORDER BY stock_out_inventories.id DESC LIMIT 1
      )
    SQL

    Car.connection.execute(query.squish!)
  end

  def change
    add_column :cars, :seller_id, :integer, comment: "成交员工"
  end
end
