class AddOrderStateToChaDoctorRecordHub < ActiveRecord::Migration
  def change
    add_column :cha_doctor_record_hubs, :order_state, :string, comment: "购买报表同步返回结果的状态"
    add_column :cha_doctor_record_hubs, :notify_state, :string, comment: "购买报表异步通知结果的状态"
  end
end
