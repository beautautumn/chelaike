class AddEstimatedGrossProfitToCars < ActiveRecord::Migration
  def change
    add_column :cars, :estimated_gross_profit_cents, :bigint, comment: "预期毛利"
  end
end
