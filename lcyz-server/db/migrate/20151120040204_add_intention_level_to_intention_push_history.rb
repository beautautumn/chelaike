class AddIntentionLevelToIntentionPushHistory < ActiveRecord::Migration
  def change
    add_column :intention_push_histories, :intention_level_id, :integer, index: true, comment: "意向等级ID"
  end
end
