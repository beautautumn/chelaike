class AddSloganToSiteConfiguration < ActiveRecord::Migration[5.0]
  def change
    add_column :site_configurations, :slogan, :string, comment: "网站对应的slogan图片"
  end
end
