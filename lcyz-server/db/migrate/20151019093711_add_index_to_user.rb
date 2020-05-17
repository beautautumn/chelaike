class AddIndexToUser < ActiveRecord::Migration
  def change
    add_index :users, :authorities, name: "users_authorities_alliance_manage", where: "'联盟管理' = ANY (authorities)"
  end
end
