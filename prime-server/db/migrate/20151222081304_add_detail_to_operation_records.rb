class AddDetailToOperationRecords < ActiveRecord::Migration
  def change
    add_column :operation_records, :detail, :jsonb, default: {}, comment: "详情"
  end
end
