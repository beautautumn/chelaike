class CreateWechatMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_messages, comment: "微信消息" do |t|
      t.string :key, comment: "事件key"
      t.string :app_id, comment: "微信公众号 app_id"
      t.string :message_type, comment: "消息类型"
      t.jsonb :content, default: {}, comment: "消息内容"
      t.timestamps null: false
    end

    add_index :wechat_messages, [:app_id, :key], unique: true
  end
end
