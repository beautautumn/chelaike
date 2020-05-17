class AddBatchOfFinishedColumnToTaskStatistics < ActiveRecord::Migration
  def change
    remove_column :task_statistics, :intention_finished

    add_column :task_statistics, :pending_interviewing_finished, :integer, array: true, comment: "今日待接待已完成"
    add_column :task_statistics, :pending_processing_finished, :integer, array: true, comment: "今日待跟进已完成"
    add_column :task_statistics, :expired_interviewed_finished, :integer, array: true, comment: "过期未接待已完成"
    add_column :task_statistics, :expired_processed_finished, :integer, array: true, comment: "过期未跟进已完成"
  end
end
