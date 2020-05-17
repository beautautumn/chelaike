class RemoveConfigFromChatSession < ActiveRecord::Migration
  def change
    remove_column :chat_sessions, :mute_notify
    remove_column :chat_sessions, :sticky_on_top
  end
end
