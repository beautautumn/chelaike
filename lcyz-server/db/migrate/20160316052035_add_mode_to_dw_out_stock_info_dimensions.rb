class AddModeToDwOutStockInfoDimensions < ActiveRecord::Migration
  def change
    add_column :dw_out_stock_info_dimensions, :mode, :string, index: true, comment: "出库方式"
  end
end
