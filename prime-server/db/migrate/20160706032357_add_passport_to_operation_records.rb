class AddPassportToOperationRecords < ActiveRecord::Migration
  def change
    add_column :operation_records, :user_passport, :jsonb, default: {}, comment: "操作用户信息"
  end
end
