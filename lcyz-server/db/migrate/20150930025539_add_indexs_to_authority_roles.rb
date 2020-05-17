class AddIndexsToAuthorityRoles < ActiveRecord::Migration
  def change
    add_index :authority_roles, :name
  end
end
