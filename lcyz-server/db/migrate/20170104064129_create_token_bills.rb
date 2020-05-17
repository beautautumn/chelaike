class CreateTokenBills < ActiveRecord::Migration
  def change
    create_table :token_bills, comment: "车币账单" do |t|
      t.string :state, comment: "车币支付状态"
      t.string :action_type, comment: "事件类型"
      t.string :payment_type, comment: "收支类型"
      t.bigint :amount_cents, comment: "金额"
      t.integer :operator_id, comment: "事件的操作人"
      t.jsonb :action_abstraction, comment: "事件的概要描述"
      t.integer :owner_id, comment: "Token的拥有者，可能为公司或个人"
      t.string :token_type, comment: "token类型"
      t.integer :company_id, comment: "操作人所属公司"
      t.integer :shop_id, comment: "操作人所属店铺"

      t.timestamps null: false
    end
  end
end
