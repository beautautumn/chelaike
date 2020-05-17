class CreateDetectionConfigs < ActiveRecord::Migration
  def change
    create_table :detection_configs, comment: "检测报告平台配置" do |t|
      t.string :platform_name, comment: "平台名"
      t.string :key, comment: "平台key"
      t.integer :c_id, comment: "对应商家id"
      t.string :c_code, comment: "商家code"

      t.timestamps null: false
    end
  end
end
