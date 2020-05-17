class CreateServiceAppointments < ActiveRecord::Migration
  def change
    create_table :service_appointments, comment: "服务预约" do |t|
      t.belongs_to :company, index: true, comment: "公司ID"
      t.string :service_appointment_type, index: true, comment: "预约类型"
      t.string :customer_name, comment: "客户姓名"
      t.string :customer_phone, comment: "客户电话"
      t.string :state, comment: "状态", default: "pending", index: true
      t.text :note, comment: "其他说明"

      t.timestamps null: false
    end
  end
end
