class AddLogoToChatGroup < ActiveRecord::Migration
  def change
    add_column :chat_groups, :logo, :string, comment: "群组logo"
  end
end
