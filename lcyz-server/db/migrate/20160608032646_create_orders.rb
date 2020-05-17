class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, commont: "订单" do |t|
      t.integer :company_id
      t.integer :user_id
      t.string :app_id, commont: "已删除"
      t.string :channel, commont: "支付方式"
      t.integer :amount_cents, commont: "支付金额"
      t.string :currency, commont: "支付货币单位"
      t.string :client_ip, commont: "客户端IP"
      t.string :subject, commont: "已经删除"
      t.string :body, commont: "已经删除"
      t.integer :status, commont: "订单状态"
      t.integer :orderable_id, commont: "多态"
      t.string :orderable_type, commont: "多态"
      t.integer :quantity, commont: "数量"
      t.timestamps null: false
    end
  end
end
