class AddRcTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rc_token, :string, comment: "融云token"
  end
end
