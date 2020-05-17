class CreateFinanceCarFees < ActiveRecord::Migration
  def change
    create_table :finance_car_fees, comment: "车辆费用" do |t|
      t.references :car, index: true, foreign_key: true, comment: "关联车辆"
      t.integer :creator_id, index: true, comment: "项目创建者"
      t.string :category, comment: "所属项目分类"
      t.string :item_name, comment: "具体项目名"
      t.integer :amount_cents, comment: "费用数额"
      t.date :fee_date, comment: "费用日期"
      t.text :note, comment: "说明"
      t.integer :user_id, comment: "关联用户"

      t.timestamps null: false
    end
  end
end
