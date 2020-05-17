class CreateUserChatGroups < ActiveRecord::Migration
  def change
    create_table :user_chat_groups do |t|
      t.belongs_to :user, index: true
      t.belongs_to :chat_group, index: true
      t.string :nick_name
      t.timestamps null: false
    end
  end
end
