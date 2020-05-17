class AddActiveTagAndHonestyTagAndOwnBrandTagAndAvatarToAlliances < ActiveRecord::Migration
  def change
    add_column :alliances, :active_tag, :boolean, default: true, index: true, comment: "活跃标识"
    add_column :alliances, :honesty_tag, :boolean, index: true, comment: "诚信标识"
    add_column :alliances, :own_brand_tag, :boolean, index: true, comment: "品牌商家标识"
    add_column :alliances, :avatar, :string, comment: "联盟头像"
    add_column :alliances, :note, :text, comment: "联盟说明"
  end
end
