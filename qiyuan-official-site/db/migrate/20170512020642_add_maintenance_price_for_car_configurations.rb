class AddMaintenancePriceForCarConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :car_configurations, :maintenance_price_cents, :integer, comment: "维保查询价格"
  end
end
