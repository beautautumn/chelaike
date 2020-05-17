class CreateIntentionAppointmentCars < ActiveRecord::Migration
  def change
    create_table :intention_appointment_cars, comment: "预约看车" do |t|
      t.datetime :appointment_time, comment: "预约时间"
      t.integer :company_id, comment: "归属车商"
      t.references :car, index: true, foreign_key: true, comment: "预约车辆"
      t.references :intention, index: true, foreign_key: true, comment: "关系的意向"
      t.text :description, comment: "预约说明"
      t.text :note, comment: "备注"

      t.timestamps null: false
    end
  end
end
