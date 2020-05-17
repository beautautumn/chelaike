class AddEstimatedCompletedAtToPrepareRecords < ActiveRecord::Migration
  def change
    add_column :prepare_records, :estimated_completed_at, :date, comment: "预计完成时间"
  end
end
