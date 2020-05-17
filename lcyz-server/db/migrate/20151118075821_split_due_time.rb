class SplitDueTime < ActiveRecord::Migration
  def change
    remove_column :intentions, :due_time

    add_column :intentions, :interviewed_time, :datetime, index: true, comment: "预约时间"
    add_column :intentions, :processing_time, :datetime, index: true, comment: "跟进时间"

    remove_column :intention_push_histories, :due_time

    add_column :intention_push_histories, :interviewed_time, :datetime, index: true, comment: "预约时间"
    add_column :intention_push_histories, :processing_time, :datetime, index: true, comment: "跟进时间"
  end
end
