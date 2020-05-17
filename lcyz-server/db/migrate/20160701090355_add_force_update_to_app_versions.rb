class AddForceUpdateToAppVersions < ActiveRecord::Migration
  def change
    add_column :app_versions, :force_update, :boolean, default: false, comment: "强制更新"
  end
end
