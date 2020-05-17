class AddEstimatedGrossProfitToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :estimated_gross_profit_cents, :bigint, index: true, default: 0, comment: "预期毛利"
  end
end
