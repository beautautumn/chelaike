class RenameIntentionExpirationsExpirationDaysToRecoveryTime < ActiveRecord::Migration
  def change
    rename_column :intention_expirations, :expiration_days, :recovery_time
  end
end
