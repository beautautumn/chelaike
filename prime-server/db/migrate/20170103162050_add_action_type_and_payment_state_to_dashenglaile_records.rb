class AddActionTypeAndPaymentStateToDashenglaileRecords < ActiveRecord::Migration
  def change
    add_column :dashenglaile_records, :action_type, :string, default: "new", comment: "记录的查询类型"
    add_column :dashenglaile_records, :payment_state, :string, default: "unpaid", comment: "支付状态"
  end
end
