class CreateWechatRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_records, comment: "微信操作记录" do |t|
      t.integer :wechat_app_user_relation_id, index: true
      t.string :action, comment: "操作"
      t.jsonb :data, default: {}, comment: "数据记录"
      t.timestamps null: false
    end
  end
end
