class AddSyncableToChe168PublishRecord < ActiveRecord::Migration
  def change
    add_column :che168_publish_records, :syncable, :boolean, default: false, comment: "是否同步"
  end
end
