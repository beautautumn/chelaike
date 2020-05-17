class AddOwnerTypeToAlliances < ActiveRecord::Migration
  def change
    add_column :alliances, :owner_type, :string, comment: "联盟所属公司多态"

    Alliance.update_all(owner_type: "Company")
  end
end
