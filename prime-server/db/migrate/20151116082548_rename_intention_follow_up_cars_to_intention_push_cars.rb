class RenameIntentionFollowUpCarsToIntentionPushCars < ActiveRecord::Migration
  def change
    rename_column :intention_follow_up_cars, :intention_follow_up_history_id, :intention_push_history_id
    rename_table :intention_follow_up_cars, :intention_push_cars
  end
end
