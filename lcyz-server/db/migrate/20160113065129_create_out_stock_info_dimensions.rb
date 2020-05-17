class CreateOutStockInfoDimensions < ActiveRecord::Migration
  def change
    create_table :out_stock_info_dimensions, comment: "出库维度" do |t|
      t.string :stock_out_inventory_type, comment: "出库类型"
      t.date :stock_out_at, comment: "出库日期"
      t.integer :stock_out_at_month, comment: "出库日期所在月份"
      t.integer :stock_out_at_year, comment: "出库日期所在年份"
      t.integer :closing_cost_cents, comment: "成交价"

      t.timestamps null: false
    end
  end
end
