class CreateDetectionReports < ActiveRecord::Migration
  def change
    create_table :detection_reports, comment: "检测报告" do |t|
      t.string :report_type, comment: "报告类型"
      t.integer :car_id, comment: "关联的车辆id"
      t.string :url, comment: "生成报告的地址"
      t.string :platform_name, comment: "对应的检测平台名"

      t.timestamps null: false
    end
  end
end
