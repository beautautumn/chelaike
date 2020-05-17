class AddLoanDataToCarConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :car_configurations, :loan_data, :jsonb, null: false, default: '{}', comment: "贷款配置信息"
  end
end
