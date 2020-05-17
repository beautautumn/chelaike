class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders, comment: "支付订单" do |t|
      t.integer :order_no, comment: "订单号"
      t.integer :amount_cents, comment: "订单金额(分)"
      t.string :channel, comment: "支付渠道"
      t.string :currency, comment: "货币类型"
      t.string :client_ip, comment: "客户端IP"
      t.references :tenant, foreign_key: true, comment: "所属租户"
      t.string :app_id, comment: "Ping++ AppID"
      t.string :open_id, comment: "微信用户 OpenID"
      t.string :status, comment: "订单状态"
      t.string :subject
      t.string :body
      t.integer :orderable_id, comment: "多态"
      t.string :orderable_type, comment: "多态"

      t.timestamps
    end
  end
end
