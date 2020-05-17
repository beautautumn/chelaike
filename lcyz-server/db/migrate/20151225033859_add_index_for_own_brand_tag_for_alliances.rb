class AddIndexForOwnBrandTagForAlliances < ActiveRecord::Migration
  def change
    add_index :alliances, :own_brand_tag
  end
end
