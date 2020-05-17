class AddIndexsToUsers < ActiveRecord::Migration
  def change
    add_index :users, :manager_id
    add_index :users, :name
    add_index :users, :phone
    add_index :users, :state
  end
end
