class ChangeOperationRecordUserTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :operation_records, :user_type, "User"
  end
end
