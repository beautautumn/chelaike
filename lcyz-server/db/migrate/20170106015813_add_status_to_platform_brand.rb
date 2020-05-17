class AddStatusToPlatformBrand < ActiveRecord::Migration
  def change
    add_column :platform_brands, :status, :boolean, default: false
  end
end
