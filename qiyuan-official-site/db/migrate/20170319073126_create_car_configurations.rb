class CreateCarConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :car_configurations, comment: "车辆配置" do |t|
      t.decimal :down_payments, comment: "首付比例"
      t.decimal :interest_rate, comment: "贷款利率"
      t.integer :loan_term, comment: "贷款周期，单位为月"
      t.references :tenant, foreign_key: true, comment: "所归属租户"

      t.timestamps
    end
  end
end
