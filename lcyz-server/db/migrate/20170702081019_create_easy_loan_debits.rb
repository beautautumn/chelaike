class CreateEasyLoanDebits < ActiveRecord::Migration
  def change
    create_table :easy_loan_debits, comment: "借款方统计信息" do |t|
      t.integer :inventory_amount, comment: "计算月库存资金量"
      t.decimal :operating_health,  comment: "计算月经营健康评级"
      t.decimal :industry_rating, default:  3,  comment: "设置借方行业风评"
      t.decimal :assets_debts_rating, default: 0.6, comment: "设置借方资产负债率"
      t.decimal :comprehensive_rating,  comment: "计算月综合评级"

      t.timestamps null: false
    end
  end
end
