class ChangeIsAlianceContactToIsAllianceContactForUser < ActiveRecord::Migration
  def change
    rename_column :users, :is_aliance_contact, :is_alliance_contact
  end
end
