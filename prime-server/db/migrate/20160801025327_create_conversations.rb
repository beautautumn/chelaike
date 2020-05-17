class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.references :user, index: true, foreign_key: true, comment: "所属用户"
      t.integer :target_id, null: false, comment: "会话类型"
      t.string :conversation_type, null: false, comment: "目标 Id。根据不同的 conversationType，可能是用户 Id、讨论组 Id、群组 Id 或聊天室 Id。"
      t.boolean :is_top, null: false, default: false, comment: "置顶"
      t.boolean :is_blocked, null: false, default: false, comment: "免打扰"
      t.timestamps null: false
    end
  end
end
