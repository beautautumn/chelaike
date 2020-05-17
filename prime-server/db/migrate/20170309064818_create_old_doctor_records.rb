class CreateOldDoctorRecords < ActiveRecord::Migration
  def change
    create_table :old_doctor_records, comment: "老司机查询记录" do |t|
      t.integer :user_id, index: true, foreign_key: true, comment: "查询的用户"
      t.string :user_name, comment: "查询用户名"
      t.integer :company_id, index: true, foreign_key: true, comment: "所属公司"
      t.integer :shop_id, comment: "所属shop"
      t.string :order_id, comment: "返回的订单ID"
      t.string :state, comment: "本记录状态"
      t.string :payment_state, "支付状态"
      t.string :action_type, "查询类型，new,refetch"
      t.decimal :token_price, comment: "花费的车币"
      t.integer :token_id, comment: "扣费的token"
      t.string :token_type, comment: "扣费的token类型"

      t.timestamps null: false
    end
  end
end
