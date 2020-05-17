class CreateChaDoctorRecordHubs < ActiveRecord::Migration
  def change
    create_table :cha_doctor_record_hubs, comment: "查博士报告" do |t|
      # 请求参数部分
      t.string :vin, comment: "vin码"
      t.string :brand_name, comment: "品牌"
      t.string :engine_no, comment: "发动机号"
      t.string :license_plate, comment: "车牌号"
      t.datetime :sent_at, comment: "请求发送时间"

      # 报告内容相关
      t.string   :order_id, comment: "订单ID"
      t.datetime :make_report_at, comment: "报告生成时间"
      t.string :report_no, comment: "报告编号"
      t.jsonb :report_details, default: [], comment: "详细报告"
      t.string :pc_url, comment: "生成报告的电脑端URL"
      t.string :mobile_url, comment: "生成报告的手机端URL"

      # 回调通知相关
      t.datetime :fetch_info_at, comment: "拉取报告的时间"
      t.datetime :notify_at, comment: "通知回调时间"
      t.string :order_status, comment: "查询结果状态码"
      t.string :order_message, comment: "查询结果对应消息"
      t.string :notify_status, comment: "异步回调结果状态"
      t.string :notify_message, comment: "异步回调结果消息"

      t.timestamps null: false
    end
  end
end
