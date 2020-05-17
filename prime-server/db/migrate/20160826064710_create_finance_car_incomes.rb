class CreateFinanceCarIncomes < ActiveRecord::Migration
  def change
    create_table :finance_car_incomes, comment: "财务管理-单车成本和收益" do |t|
      t.references :car, index: true, foreign_key: true, comment: "关联车辆"
      t.references :company, index: true, foreign_key: true, comment: "所属公司"
      t.integer :payment_cents, comment: "入库付款"
      t.integer :prepare_cost_cents, comment: "整备费用"
      t.integer :handling_charge_cents, comment: "手续费"
      t.integer :commission_cents, comment: "佣金"
      t.integer :percentage_cents, comment: "提成/分成"
      t.integer :fund_cost_cents, comment: "资金成本"
      t.integer :misc_cost_cents, comment: "其他成本"
      t.integer :receipt_cents, comment: "出库收款"
      t.integer :misc_profit_cents, comment: "其他收益"

      t.timestamps null: false
    end
  end
end
