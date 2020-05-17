class CreateTaskStatistics < ActiveRecord::Migration
  def change
    create_table :task_statistics, comment: "任务统计" do |t|
      t.belongs_to :user, index: true, comment: "用户ID"
      t.belongs_to :shop, index: true, comment: "分店ID"
      t.belongs_to :company, index: true, comment: "公司ID"

      t.date :record_date, index: true, comment: "记录日期"
      t.integer :intention_interviewed, array: true, comment: "今日意向已接待"
      t.integer :intention_processed, array: true, comment: "今日意向已跟进"
      t.integer :intention_completed, array: true, comment: "今日意向已经成交"
      t.integer :intention_failed, array: true, comment: "今日意向已失败"
      t.integer :intention_invalid, array: true, comment: "今日意向已失效"

      t.timestamps null: false
    end
  end
end
