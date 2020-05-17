class AddEstimatedGrossProfitRateToCars < ActiveRecord::Migration
  def change
    add_column :cars, :estimated_gross_profit_rate, :float, comment: "预期毛利率"

    add_column :dw_car_dimensions, :estimated_gross_profit_rate, :float, comment: "预期毛利率"
  end
end
