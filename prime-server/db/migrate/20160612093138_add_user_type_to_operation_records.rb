class AddUserTypeToOperationRecords < ActiveRecord::Migration
  def change
    add_column :operation_records, :user_type, :string

    OperationRecord.update_all(user_type: "User")
  end
end
