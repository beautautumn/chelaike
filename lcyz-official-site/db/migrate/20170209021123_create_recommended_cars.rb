class CreateRecommendedCars < ActiveRecord::Migration[5.0]
  def change
    create_table :recommended_cars, comment: "首页推荐车辆" do |t|
      t.integer :car_id, comment: "车辆id"
      t.integer :order, comment: "排序"
      t.references :tenant, foreign_key: true, comment: "所归属租户"

      t.timestamps
    end
  end
end
