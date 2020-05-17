class AddIconToSiteConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :site_configurations, :icon, :string, comment: "网站对应的icon"
    add_column :site_configurations, :icp, :string, comment: "网站对应的备案号"
  end
end
