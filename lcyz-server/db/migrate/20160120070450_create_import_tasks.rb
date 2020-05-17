class CreateImportTasks < ActiveRecord::Migration
  def change
    create_table :import_tasks, comment: "意向导入记录" do |t|
      t.integer :user_id, index: true, comment: "操作人"
      t.string :state, default: "pending", comment: "状态"
      t.string :import_task_type, comment: "记录类型"
      t.jsonb :info, default: {}, comment: "相关信息"

      t.timestamps null: false
    end

    add_column :intentions, :import_task_id, :integer, index: true, comment: "意向导入记录ID"
  end
end
