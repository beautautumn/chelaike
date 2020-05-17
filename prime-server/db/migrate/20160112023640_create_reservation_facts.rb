class CreateReservationFacts < ActiveRecord::Migration
  def change
    create_table :reservation_facts, comment: "预定事实" do |t|

      t.integer :car_id, index: true, comment: "车辆ID"
      t.integer :reservation_info_dimension_id, index: true, comment: "预定信息维度ID"
      t.integer :car_dimension_id, index: true, comment: "车辆维度ID"
      t.integer :company_dimension_id, index: true, comment: "公司维度ID"

      t.timestamps null: false
    end
  end
end
