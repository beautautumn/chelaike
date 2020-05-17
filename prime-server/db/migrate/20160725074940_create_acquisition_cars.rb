class CreateAcquisitionCars < ActiveRecord::Migration
  def change
    create_table :acquisition_cars, comment: "收车信息" do |t|
      t.string :brand_name, comment: "品牌名称"
      t.string :series_name, comment: "车系名称"
      t.string :style_name, comment: "车型名称"
      t.integer :acquirer_id, index: true, foreign_key: true, comment: "发布收车信息的人ID"
      t.date :licensed_at, comment: "licensed_at"
      t.integer :new_car_guide_price_cents, comment: "新车指导价"
      t.integer :new_car_final_price_cents, comment: "新车完税价"
      t.date :manufactured_at, comment: "出厂日期"
      t.float :mileage, comment: "表显里程(万公里)"
      t.string :exterior_color, comment: "外饰颜色"
      t.string :interior_color, comment: "内饰颜色"
      t.float :displacement, comment: "排气量"
      t.integer :prepare_estimated_cents, comment: "整备预算"
      t.hstore :manufacturer_configuration, comment: "车辆配置"
      t.integer :valuation, comment: "收车人估价"
      t.jsonb :note, comment: "备注"
      t.string :state, comment: "收车信息状态"

      t.timestamps null: false
    end
  end
end
