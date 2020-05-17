class AddAddressToShops < ActiveRecord::Migration
  def change
    add_column :shops, :address, :string, comment: "地址"
  end
end
