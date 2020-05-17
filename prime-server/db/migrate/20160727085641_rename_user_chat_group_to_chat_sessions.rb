class RenameUserChatGroupToChatSessions < ActiveRecord::Migration
  def change
    rename_table :user_chat_groups, :chat_sessions
    remove_column :chat_sessions, :chat_group_id
    add_reference :chat_sessions, :target, polymorphic: true
    add_index :chat_sessions, [:target_id, :target_type, :user_id],
              unique: true, name: "uniq_chat_sessions"
  end
end
