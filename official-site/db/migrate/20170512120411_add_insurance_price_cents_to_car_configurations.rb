class AddInsurancePriceCentsToCarConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :car_configurations, :insurance_price_cents, :bigint, default: 0, comment: "用户查询保险记录详情时价格"
  end
end
