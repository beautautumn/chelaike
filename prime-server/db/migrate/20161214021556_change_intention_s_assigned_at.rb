class ChangeIntentionSAssignedAt < ActiveRecord::Migration
  def change
    rename_column :intentions, :assigned_at, :alliance_assigned_at
  end
end
