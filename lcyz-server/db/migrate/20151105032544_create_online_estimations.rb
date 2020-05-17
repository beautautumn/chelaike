class CreateOnlineEstimations < ActiveRecord::Migration
  def change
    create_table :online_estimations, comment: "在线评估" do |t|
      t.string :brand_name, comment: "品牌"
      t.string :series_name, comment: "车系"
      t.string :style_name, comment: "车型"
      t.string :licensed_at, comment: "上牌日期"
      t.float :mileage, comment: "表显里程(万公里)"
      t.string :customer_phone, comment: "手机号码"

      t.timestamps null: false
    end
  end
end
