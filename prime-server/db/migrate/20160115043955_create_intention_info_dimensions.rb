class CreateIntentionInfoDimensions < ActiveRecord::Migration
  def change
    create_table :intention_info_dimensions, comment: "意向信息维度" do |t|
      t.integer :intention_id, index: true, comment: "意向ID"
      t.string :source, comment: "意向创建源"
      t.string :intention_type, comment: "意向类型"
      t.datetime :intention_created_at, comment: "意向创建日期"
      t.integer :intention_created_at_month, comment: "意向创建日期所在月份"
      t.integer :intention_created_at_year, comment: "意向创建日期所在年份"

      t.timestamps null: false
    end
  end
end
