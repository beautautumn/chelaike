class CreateCarAppointments < ActiveRecord::Migration
  def change
    create_table :car_appointments, comment: "预约看车" do |t|

      t.integer :car_id, index: true, comment: "车辆ID"
      t.string :phone, comment: "手机"
      t.string :name, comment: "姓名"
      t.integer :seller_id, index: true, comment: "销售员ID"

      t.timestamps null: false
    end
  end
end
