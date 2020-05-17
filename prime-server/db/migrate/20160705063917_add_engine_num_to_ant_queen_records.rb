class AddEngineNumToAntQueenRecords < ActiveRecord::Migration
  def change
    add_column :ant_queen_records, :engine_num, :string
    add_column :ant_queen_records, :car_brand_id, :integer
    add_column :ant_queen_records, :token_price, :decimal, precision: 8, scale: 2
    add_column :ant_queen_records, :pre_token_price, :decimal, precision: 8, scale: 2

    add_column :maintenance_records, :token_price, :decimal, precision: 8, scale: 2
    add_column :maintenance_records, :pre_token_price, :decimal, precision: 8, scale: 2
  end
end
