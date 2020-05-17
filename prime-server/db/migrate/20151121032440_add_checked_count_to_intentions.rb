class AddCheckedCountToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :checked_count, :integer, comment: "到店/评估次数"
    add_column :intention_push_histories, :checked_count, :integer, comment: "到店/评估次数"
    add_column :intention_push_histories, :executor_id, :integer, index: true, comment: "执行人"
  end
end
