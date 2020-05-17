class RenameIntentionFollowUpHistoriesToIntentionPushHistories < ActiveRecord::Migration
  def change
    drop_table :intention_push_histories if ActiveRecord::Base.connection.table_exists? 'intention_push_histories'
    rename_table :intention_follow_up_histories, :intention_push_histories
  end
end
