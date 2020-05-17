class AddCompanyIdToSiteConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :site_configurations, :company_id, :integer, index: true, comment: "对应车来客公司"
  end
end
