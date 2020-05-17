class AddRecoveryHourToIntentionExpirations < ActiveRecord::Migration
  def change
    add_column :intention_expirations, :recovery_hour, :integer, comment: "过期小时"
  end
end
