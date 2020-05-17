class AddChangeIdForOrders < ActiveRecord::Migration
  def change
    add_column :orders, :charge_id, :string, comment: "ChargeID，由pingpp返回"
    add_column :orders, :action, :integer, comment: "订单类别"
  end
end
