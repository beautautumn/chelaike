class CreateTransferHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :transfer_histories do |t|
      t.integer :car_id, comment: "车辆id"
      t.datetime :transfer_at, comment: "过户时间"
      t.string :home_location, comment: "归属地"
      t.string :transfer_type, comment: "过户类型 person business"
      t.string :description, comment: "过户描述"

      t.timestamps
    end
  end
end
