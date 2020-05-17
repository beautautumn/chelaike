class CreateAllianceStockOutInventories < ActiveRecord::Migration
  def change
    drop_table :alliance_stock_out_inventories if ActiveRecord::Base.connection.table_exists? 'alliance_stock_out_inventories'
    create_table :alliance_stock_out_inventories, comment: "联盟出库清单" do |t|
      t.integer :from_car_id, index: true, comment: "出库车辆 ID"
      t.integer :to_car_id, index: true, comment: "入库(复制)车辆 ID"
      t.integer :alliance_id, index: true, comment: "联盟 ID"
      t.integer :from_company_id, index: true, comment: "出库公司 ID"
      t.integer :to_company_id, index: true, comment: "入库公司 ID"
      t.date :completed_at, comment: "出库日期"
      t.bigint :closing_cost_cents, comment: "成交价格"
      t.bigint :deposit_cents, comment: "定金"
      t.bigint :remaining_money_cents, comment: "余款"
      t.text :note, comment: "备注"
      t.date :refunded_at, comment: "退车时间"
      t.bigint :refunded_price_cents, comment: "退车金额"
      t.integer :seller_id, index: true, comment: "成交员工 ID"
      t.boolean :current, comment: "是否为当前联盟出库记录"

      t.timestamps null: false
    end
  end
end
