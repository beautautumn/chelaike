class AddAppIdToAppVersions < ActiveRecord::Migration
  def change
    add_column :app_versions, :app_id, :integer
  end
end
