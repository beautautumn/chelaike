class AddPaymentStateToChaDoctorRecord < ActiveRecord::Migration
  def change
    add_column :cha_doctor_records, :payment_state, :string, default: "unpaid", comment: "支付状态"
  end
end
