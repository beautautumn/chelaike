class AddSellerIdToDwOutStockInfoDimensions < ActiveRecord::Migration
  def change
    add_column :dw_out_stock_info_dimensions, :seller_id, :integer, index: true, comment: "销售员ID"
  end
end
