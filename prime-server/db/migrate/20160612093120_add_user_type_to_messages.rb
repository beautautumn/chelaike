class AddUserTypeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_type, :string

    Message.update_all(user_type: "User")
  end
end
