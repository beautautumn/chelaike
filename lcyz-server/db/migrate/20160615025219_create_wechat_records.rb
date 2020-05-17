class CreateWechatRecords < ActiveRecord::Migration
  def change
    create_table :wechat_records do |t|
      t.string :app_id, comment: "微信app_id"
      t.string :open_id, index: true, comment: "微信用户open id"
      t.string :action, comment: "操作"
      t.jsonb :data, default: {}, comment: "数据记录"
      t.timestamps null: false
    end

    add_index :wechat_records, [:app_id, :open_id]
  end
end
