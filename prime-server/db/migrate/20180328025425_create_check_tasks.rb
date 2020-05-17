class CreateCheckTasks < ActiveRecord::Migration
  def change
    create_table :check_tasks, comment: "检测任务" do |t|
      t.string :task_type, comment: "任务类型"
      t.string :task_report_h5_url, comment: "生成报告url"
      t.integer :car_id, index: true, foreign_key: true, comment: "对应车辆"
      t.integer :create_staff_id, comment: "任务创建者(车商)"
      t.integer :check_staff_id, comment: "检测者(检测员)"
      t.string :task_state, comment: "检测任务状态"
      t.integer :trade_id, :integer, comment: "对应erp里车辆id"
      t.string :report_type, :string, comment: "检测报告类型"
      t.string :report_url, :string, comment: "检测报告地址"

      t.timestamps null: false
    end
  end
end
