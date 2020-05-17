class AddConfigToChatSession < ActiveRecord::Migration
  def change
    add_column :chat_sessions, :mute_notify, :boolean,
               null: false, default: false, comment: "免打扰"
    add_column :chat_sessions, :sticky_on_top, :boolean,
               null: false, default: false, comment: "置顶"
  end
end
