class CreateIntentionSharedUsers < ActiveRecord::Migration
  def change
    create_table :intention_shared_users, comment: "意向共享用户中间表" do |t|
      t.references :intention, index: true, foreign_key: true, comment: "关联的意向"
      t.references :user, index: true, foreign_key: true, comment: "分享给的用户"
      t.integer :customer_id, comment: "客户ID"

      t.timestamps null: false
    end
  end
end
