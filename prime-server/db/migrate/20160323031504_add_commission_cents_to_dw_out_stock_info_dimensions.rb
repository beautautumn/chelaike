class AddCommissionCentsToDwOutStockInfoDimensions < ActiveRecord::Migration
  def change
    add_column :dw_out_stock_info_dimensions, :commission_cents, :bigint, comment: "佣金"
  end
end
