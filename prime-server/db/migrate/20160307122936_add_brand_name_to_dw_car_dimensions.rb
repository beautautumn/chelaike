class AddBrandNameToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :brand_name, :string, index: true, comment: "品牌名称"
  end
end
