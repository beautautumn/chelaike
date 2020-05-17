class CreateOldDriverRecordHubs < ActiveRecord::Migration
  def change
    create_table :old_driver_record_hubs, comment: "老司机报告内容" do |t|
      t.string :vin, comment: "vin码"
      t.string :order_id, comment: "对方订单ID"
      t.string :engine_num, comment: "发动机号"
      t.string :licence_no, comment: "车牌号"
      t.string :id_numbers, comment: "身份证号，以逗号分隔"
      t.datetime :sent_at, comment: "发送时间"
      t.datetime :notify_at, comment: "回调通知时间"
      t.string :make, comment: "车型信息"
      t.jsonb :insurance, comment: "保险区间"
      t.jsonb :clainms, comment: "事故"

      t.timestamps null: false
    end
  end
end
