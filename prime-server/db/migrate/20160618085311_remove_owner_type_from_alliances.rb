class RemoveOwnerTypeFromAlliances < ActiveRecord::Migration
  def change
    remove_column :alliances, :owner_type, :string
  end
end
