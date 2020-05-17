class AddShopIdToTransferRecords < ActiveRecord::Migration
  def migrate(dir)
    super

    query = [TransferRecord, CarReservation, PrepareRecord, StockOutInventory].map do |klass|
      table_name = klass.table_name

      <<-SQL
        UPDATE #{table_name}
          SET shop_id = cars.shop_id
          FROM cars
          WHERE #{table_name}.car_id = cars.id
      SQL
    end.join(";")

    Car.connection.execute(query.squish!)
  end

  def change
    add_column :transfer_records, :shop_id, :integer, index: true, comment: "分店ID"
    add_column :car_reservations, :shop_id, :integer, index: true, comment: "分店ID"
    add_column :prepare_records, :shop_id, :integer, index: true, comment: "分店ID"
    add_column :stock_out_inventories, :shop_id, :integer, index: true, comment: "分店ID"
  end
end
