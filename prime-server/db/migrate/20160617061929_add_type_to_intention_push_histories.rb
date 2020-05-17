class AddTypeToIntentionPushHistories < ActiveRecord::Migration
  def change
    add_column :intention_push_histories, :type, :string, comment: "STI"
  end
end
