class ModifyEasyLoadSetting < ActiveRecord::Migration
  def change
    remove_column :easy_loan_settings, :rate_category
    remove_column :easy_loan_settings,  :rate_weight

    # 健康评级
    add_column  :easy_loan_settings,  :gross_rake,  :decimal, default: 0.7, comment: "（健康评级）毛利润率评级权重"
    add_column  :easy_loan_settings,  :assets_debts_rate, :decimal, default: 0.3, comment: "（健康评级）资产负债率评级权重"

    # 综合指数
    add_column  :easy_loan_settings,  :inventory_amount,  :decimal, default: 0.2, comment: "（综合指数）库存资金量权重"
    add_column  :easy_loan_settings,  :operating_health,  :decimal, default: 0.4, comment: "（综合指数）经营健康评级权重"
    add_column  :easy_loan_settings,  :industry_rating, :decimal, default: 0.4, comment:  "（综合指数）行业风评权重"
  end
end
