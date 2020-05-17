class AddIndexsToCars < ActiveRecord::Migration
  def change
    add_index :cars, :brand_name
    add_index :cars, :series_name
    add_index :cars, :style_name
    add_index :cars, :shop_id
    add_index :cars, :state
    add_index :cars, :car_type
    add_index :cars, :vin
    add_index :cars, :acquisition_type
    add_index :cars, :acquired_at
    add_index :cars, :show_price_cents
    add_index :cars, :stock_out_at
  end
end
