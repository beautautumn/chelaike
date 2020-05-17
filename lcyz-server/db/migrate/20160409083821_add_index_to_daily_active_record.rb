class AddIndexToDailyActiveRecord < ActiveRecord::Migration
  def change
    add_index :daily_active_records, :company_id
  end
end
