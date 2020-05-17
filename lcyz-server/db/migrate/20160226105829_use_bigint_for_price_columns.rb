class UseBigintForPriceColumns < ActiveRecord::Migration
  def change
    change_column :dw_acquisition_info_dimensions, :acquisition_price_cents, :integer, limit: 8, comment: "收购价"
    change_column :dw_car_dimensions, :show_price_cents, :integer, limit: 8, comment: "展厅价格"
    change_column :dw_car_dimensions, :online_price_cents, :integer, limit: 8, comment: "网络价格"
    change_column :dw_out_stock_info_dimensions, :closing_cost_cents, :integer, limit: 8, comment: "成交价"
  end
end
