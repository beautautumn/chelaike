class CreateParallelBrands < ActiveRecord::Migration
  def change
    create_table :parallel_brands, comment: "平行进口车和厂家特价车的品牌" do |t|
      t.string :name, comment: "品牌名称"
      t.string :logo_url, comment: "LOGO 图片 URL"
      t.integer :order, comment: "排序"

      t.timestamps null: false
    end
  end
end
