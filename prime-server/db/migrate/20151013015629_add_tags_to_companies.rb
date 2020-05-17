class AddTagsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :active_tag, :boolean, default: true, index: true, comment: "活跃标识"
    add_column :companies, :honesty_tag, :boolean, index: true, comment: "诚信标识"
    add_column :companies, :own_brand_tag, :boolean, index: true, comment: "品牌商家标识"
  end
end
