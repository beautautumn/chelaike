class DropDwShopDimensions < ActiveRecord::Migration
  def change
    drop_table :dw_shop_dimensions

    add_column :dw_car_dimensions, :shop_id, :integer, index: true, comment: "分店ID"
    add_column :dw_car_dimensions, :company_id, :integer, index: true, comment: "公司ID"
    remove_column :dw_car_dimensions, :shop_dimension_id
  end
end
