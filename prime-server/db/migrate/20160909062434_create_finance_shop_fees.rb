class CreateFinanceShopFees < ActiveRecord::Migration
  def change
    create_table :finance_shop_fees, comment: "单店运营运营成本和收益" do |t|
      t.references :shop, index: true, foreign_key: true, comment: "关联分店"
      t.string :month, comment: "年月"
      t.integer :location_rent_cents, comment: "场地租金"
      t.integer :salary_cents, comment: "固定工资"
      t.integer :social_insurance_cents, comment: "社保／公积金"
      t.integer :bonus_cents, comment: "奖金／福利"
      t.integer :marketing_expenses_cents, comment: "市场营销"
      t.integer :energy_fee_cents, comment: "水电"
      t.integer :office_fee_cents, comment: "办公用品"
      t.integer :communication_fee_cents, comment: "通讯费"
      t.integer :other_cost_cents, comment: "其它支出"
      t.integer :other_profit_cents, comment: "其它收入"
      t.text :note, comment: "备注"

      t.timestamps null: false
    end
  end
end
