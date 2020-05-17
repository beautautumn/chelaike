class AddShopIdToOwnerCompanies < ActiveRecord::Migration
  def change
    add_column :owner_companies, :shop_id, :integer, comment: "车商所属的分店"
  end
end
