class AddToShopIdToAllianceStockOutInventories < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL.squish!
      UPDATE alliance_stock_out_inventories
      SET to_shop_id = (
        SELECT cars.shop_id FROM cars
        WHERE alliance_stock_out_inventories.to_car_id = cars.id AND alliance_stock_out_inventories.current = 't'
        LIMIT 1
      )
    SQL

    AllianceStockOutInventory.connection.execute(query.squish!)
  end

  def change
    add_column :alliance_stock_out_inventories, :to_shop_id, :integer, index: true, comment: "入库分店 ID"
  end
end
