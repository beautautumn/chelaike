class AddExternalToInspectionReport < ActiveRecord::Migration[5.0]
  def change
    add_column :inspection_reports, :external_url, :string, comment: "外部检测报告网址"
  end
end
