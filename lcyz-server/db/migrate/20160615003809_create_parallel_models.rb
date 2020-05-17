class CreateParallelModels < ActiveRecord::Migration
  def change
    create_table :parallel_models, comment: "平行进口车和厂家特价车的车型" do |t|
      t.string :name, comment: "车型名称"
      t.string :origin, comment: "原产地"
      t.string :color, comment: "颜色"
      t.text :configuration, comment: "配置信息"
      t.string :status, comment: "状态(现车, 报关中, etc)"
      t.integer :suggested_price_cents,limit: 8, comment: "同款新车指导价"
      t.integer :sell_price_cents,limit: 8, comment: "港口自提价/销售成交价"
      t.string :model_type, comment: "平行进口车/厂家特价车"
      t.references :parallel_brand, index: true, foreign_key: true, comment: "品牌"

      t.timestamps null: false
    end
  end
end
