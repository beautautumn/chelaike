class AddIntentionPushFailReasonIdToPushHistory < ActiveRecord::Migration
  def change
    add_column :intention_push_histories, :intention_push_fail_reason_id, :integer, comment: "战败原因ID"
  end
end
