class CreatePublicPraiseSumups < ActiveRecord::Migration
  def change
    create_table :public_praise_sumups, comment: "二手车之家口碑总结" do |t|
      t.string :brand_name, comment: "品牌"
      t.string :series_name, comment: "车系"
      t.string :style_name, index: true, comment: "车型"
      t.integer :brand_id, comment: "品牌ID"
      t.integer :series_id, comment: "车系ID"
      t.integer :style_id, index: true, comment: "车型ID"

      t.jsonb :sumup, comment: "总结评价"
      t.string :quality_problems, array: true, comment: "百车故障"
      t.string :latest_exist_links, array: true, default: [], comment: "上一次口碑链接"

      t.timestamps null: false
    end

    add_index :public_praise_sumups, [:brand_id, :series_id, :style_id], name: :public_praise_sumups_brand_series_style
  end
end
