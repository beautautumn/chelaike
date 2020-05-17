class AddStockAgeToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :stock_age, :integer, index: true, comment: "库龄"
  end
end
