class CreateSiteConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :site_configurations, comment: "站点配置" do |t|
      t.string :title, comment: "SEO title"
      t.string :keyword, comment: "SEO keyword"
      t.string :description, comment: "SEO description"
      t.references :tenant, foreign_key: true, comment: "所归属租户"

      t.timestamps
    end
  end
end
