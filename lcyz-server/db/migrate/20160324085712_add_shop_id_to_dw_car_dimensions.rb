class AddShopIdToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :shop_id, :integer, index: true, commit: "分店ID"
  end
end
