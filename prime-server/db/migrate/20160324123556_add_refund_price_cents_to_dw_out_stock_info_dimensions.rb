class AddRefundPriceCentsToDwOutStockInfoDimensions < ActiveRecord::Migration
  def change
    add_column :dw_out_stock_info_dimensions, :refund_price_cents, :integer, comment: "退款金额"
  end
end
