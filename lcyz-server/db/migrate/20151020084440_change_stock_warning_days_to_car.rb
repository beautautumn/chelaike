class ChangeStockWarningDaysToCar < ActiveRecord::Migration
  def change
    rename_column :cars, :stock_warning_days, :yellow_stock_warning_days
    add_column :cars, :red_stock_warning_days, :integer, default: 45, comment: "红色预警"
    rename_column :car_price_histories, :stock_warning_days, :yellow_stock_warning_days
    add_column :car_price_histories, :red_stock_warning_days, :integer, default: 45, comment: "红色预警"
  end
end
