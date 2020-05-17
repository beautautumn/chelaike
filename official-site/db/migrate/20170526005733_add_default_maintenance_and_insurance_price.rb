class AddDefaultMaintenanceAndInsurancePrice < ActiveRecord::Migration[5.0]
  def change
    change_column :car_configurations, :maintenance_price_cents, :bigint, default: 1500, comment: "维保查询价格"
    change_column :car_configurations, :insurance_price_cents, :bigint, default: 1500, comment: "用户查询保险记录详情时价格"

    CarConfiguration.where(maintenance_price_cents: nil).update_all(maintenance_price_cents: 1500)
    CarConfiguration.where(insurance_price_cents: nil).update_all(insurance_price_cents: 1500)
  end
end
