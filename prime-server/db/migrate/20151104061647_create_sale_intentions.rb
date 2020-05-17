class CreateSaleIntentions < ActiveRecord::Migration
  def change
    create_table :sale_intentions, comment: "卖车意向" do |t|

      t.string :brand_name, comment: "品牌"
      t.string :series_name, comment: "车系"
      t.string :style_name, comment: "车款"
      t.integer :mileage, comment: "里程"
      t.date :licensed_at, comment: "上牌日期"
      t.string :phone, comment: "联系电话"

      t.timestamps null: false
    end
  end
end
