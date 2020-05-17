class AddLogoToSiteConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :site_configurations, :logo, :string, comment: "网站对应的logo"
  end
end
