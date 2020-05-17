class ChangePublishedIdForCarPublishRecords < ActiveRecord::Migration
  def up
    remove_column :car_publish_records, :published_id
    add_column    :car_publish_records, :published_id, :jsonb, comment: "同步到平台的标识，可能为{id: 1234, company_id:4321}"
  end

  def down
    remove_column :car_publish_records, :published_id, :jsonb
    add_column    :car_publish_records, :published_id, :integer
  end
end
