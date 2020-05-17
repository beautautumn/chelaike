class AddIosSourceToAppVersions < ActiveRecord::Migration
  def change
    add_column :app_versions, :ios_source, :string, comment: "ios的外部安装源"
  end
end
