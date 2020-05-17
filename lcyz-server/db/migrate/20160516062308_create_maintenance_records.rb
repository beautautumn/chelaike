class CreateMaintenanceRecords < ActiveRecord::Migration
  def change
    create_table :maintenance_records, comment: "维保记录" do |t|
      t.integer :company_id, comment: "公司ID"
      t.integer :car_id, comment: "车辆ID"
      t.string :vin
      t.integer :state
      t.integer :last_fetch_by, comment: "最后查询的用户ID"
      t.string :user_name, comment: "最后查询的用户名"
      t.timestamp :last_fetch_at, comment: "最后查询的时间"
      t.integer :maintenance_record_hub_id

      t.timestamps null: false
    end
  end
end
