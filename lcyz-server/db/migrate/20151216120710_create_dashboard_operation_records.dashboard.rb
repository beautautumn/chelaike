# This migration comes from dashboard (originally 20151216091920)
class CreateDashboardOperationRecords < ActiveRecord::Migration
  def change
    create_table :dashboard_operation_records do |t|

      t.integer :staff_id, index: true, comment: "操作员工ID"
      t.string :operation_type, comment: "操作类型"
      t.jsonb :content, comment: "操作内容"
      t.timestamps null: false
    end
  end
end
