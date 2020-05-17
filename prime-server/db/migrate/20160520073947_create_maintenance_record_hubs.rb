class CreateMaintenanceRecordHubs < ActiveRecord::Migration
  def change
    create_table :maintenance_record_hubs, comment: "维保中心" do |t|
      t.string :vin
      t.string :brand, comment: "品牌"
      t.string :style_name, comment: "车系"
      t.string :transmission, comment: "变速器"
      t.string :displacement, comment: "排气量"
      t.integer :origin, comment: "来源"
      t.datetime :report_at, comment: "报告时间"
      t.timestamps null: false
      t.json :items, default: [], comment: "详细报告"
      t.integer :order_id, null: false, comment: "订单ID"
    end
  end
end
