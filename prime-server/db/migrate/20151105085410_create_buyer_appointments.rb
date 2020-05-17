class CreateBuyerAppointments < ActiveRecord::Migration
  def change
    create_table :buyer_appointments, comment: "车辆预约" do |t|
      t.belongs_to :car, index: true, comment: "车辆ID"
      t.string :customer_name, comment: "客户姓名"
      t.string :customer_phone, comment: "客户电话"

      t.timestamps null: false
    end
  end
end
