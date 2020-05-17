class AddShopToTenant < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :shop_id, :integer, comment: "分店id"
  end
end
