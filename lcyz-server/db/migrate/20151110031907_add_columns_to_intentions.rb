class AddColumnsToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :brand_name, :string, comment: "出售车辆品牌名称"
    add_column :intentions, :series_name, :string, comment: "出售车辆车系名称"

    add_column :intentions, :price_cents, :bigint, comment: "预算/期望价格(万)"
    add_column :intentions, :color, :string, comment: "颜色"
    add_column :intentions, :mileage, :float, comment: "里程(万公里)"
    add_column :intentions, :licensed_at, :date, comment: "上牌日期"
  end
end
