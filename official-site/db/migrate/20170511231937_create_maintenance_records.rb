class CreateMaintenanceRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :maintenance_records, comment: "维保记录" do |t|
      t.string :vin, comment: "车架号"
      t.string :car_name, comment: "车辆名"
      t.string :last_date, comment: "最后入店日期"
      t.string :mileage, comment: "里程"
      t.string :new_car_warranty, comment: "新车质保"
      t.string :emission_standard, comment: "排放标准"
      t.integer :total_records_count, comment: "记录条数"
      t.jsonb :record_abstract, comment: "记录摘要"
      t.jsonb :record_detail, comment: "记录详情"
      t.integer :car_id, index: true, comment: "关联 car id"

      t.timestamps
    end
  end
end
