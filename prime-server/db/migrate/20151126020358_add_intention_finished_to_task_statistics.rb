class AddIntentionFinishedToTaskStatistics < ActiveRecord::Migration
  def change
    add_column :task_statistics, :intention_finished, :integer, array: true, comment: "今日待跟进已完成"
  end
end
