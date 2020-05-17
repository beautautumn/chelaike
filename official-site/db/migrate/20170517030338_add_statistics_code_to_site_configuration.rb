class AddStatisticsCodeToSiteConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :site_configurations, :statistics_code, :string, comment: "统计代码"
  end
end
