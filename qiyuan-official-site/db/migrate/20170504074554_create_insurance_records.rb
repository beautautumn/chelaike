class CreateInsuranceRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :insurance_records, comment: "保险理赔记录" do |t|
      t.string :vin, comment: "vin码"
      t.string :mileage, comment: "里程数"
      t.integer :total_records_count, comment: "总记录数"
      t.integer :claims_count, comment: "事故次数"
      t.jsonb :record_abstract, comment: "记录摘要"
      t.jsonb :claims_abstract, comment: "出险事故摘要"
      t.decimal :claims_total_fee_yuan, precision: 12, scale: 2, default: 0, comment: "事故总损失元"
      t.jsonb :claims_details, comment: "事故详细记录"
      t.integer :car_id, comment: "报告对应的car_id"

      t.timestamps
    end
  end
end
