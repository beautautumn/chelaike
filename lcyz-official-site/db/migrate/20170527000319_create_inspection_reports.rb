class CreateInspectionReports < ActiveRecord::Migration[5.0]
  def change
    create_table :inspection_reports, comment: "检测报告" do |t|
      t.string :source_link, comment: "检测报告文件地址"
      t.string :report_type, comment: "检测报告文件类型"
      t.references :car, index: true, comment: "关联车辆"

      t.timestamps
    end
  end
end
