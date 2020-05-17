class CreateChaDoctorRecords < ActiveRecord::Migration
  def change
    create_table :cha_doctor_records do |t|
      t.integer  :company_id, comment: "公司ID"
      t.integer  :car_id, comment: "车辆ID"
      t.integer  :shop_id, comment: "店铺ID"
      t.string   :vin
      t.string   :state
      t.string  :user_name, comment: "查询的用户名"
      t.integer :user_id, comment: "查询的用户ID"
      t.datetime :fetch_at, comment: "拉取报告的时间"
      t.integer  :cha_doctor_record_hub_id, comment: "所属报告"
      t.integer  :last_cha_doctor_record_hub_id, comment: "最新更新的报告"
      t.string   :engine_num, comment: "发动机号"
      t.decimal  :token_price, precision: 8, scale: 2
      t.string   :vin_image, comment: "vin码图片"

      t.timestamps null: false
    end
  end
end
