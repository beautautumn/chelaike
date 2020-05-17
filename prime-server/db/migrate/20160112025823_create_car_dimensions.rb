class CreateCarDimensions < ActiveRecord::Migration
  def change
    create_table :car_dimensions, comment: "车辆维度ID" do |t|

      t.integer :car_id, index: true, comment: "车辆ID"
      t.string :state, comment: "车辆状态"
      t.integer :show_price_cents, comment: "展厅价格"
      t.integer :online_price_cents, comment: "网络价格"
      t.integer :operation_record_count, comment: "操作计数"

      t.timestamps null: false
    end
  end
end
