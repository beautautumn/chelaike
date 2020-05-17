class CreateDashenglaileRecordHubs < ActiveRecord::Migration
  def change
    create_table :dashenglaile_record_hubs, comment: "大圣来了报告" do |t|
      # 请求参数部分
      t.string   :vin,                                      comment: "vin码"
      t.string   :engine_num,                               comment: "发动机号"
      t.integer  :car_brand_id,                             comment: "大圣来了品牌 ID"
      t.string   :license_plate,                            comment: "车牌号"
      t.datetime :sent_at,                                  comment: "请求发送时间"

      # 报告内容相关
      t.datetime :last_time_to_shop,                        comment: "最后进店时间"
      t.integer  :total_mileage,                            comment: "行驶的总公里数"
      t.integer  :number_of_accidents,                      comment: "事故次数"
      t.string   :car_brand,                                comment: "品牌"
      t.text     :result_description,                       comment: "报告描述"
      t.json     :result_images,                            comment: "报告图片"
      t.string   :result_status,                            comment: "报告状态"
      t.datetime :gmt_create,                               comment: "此次订单创建的时间"
      t.datetime :gmt_finish,                               comment: "此次订单完成的时间"
      t.string   :order_id,                                 comment: "订单ID"
      t.json     :result_content,                           comment: "报告内容"
      t.json     :result_report,                            comment: "报告总结"

      # 回调通知相关
      t.datetime :fetch_info_at,                            comment: "拉取报告的时间"
      t.datetime :make_report_at,                           comment: "报告生成时间"
      t.datetime :notify_time,                              comment: "通知回调时间"
      t.string   :notify_type,                              comment: "通知类型"
      t.integer  :notify_id,                                comment: "推送校验 ID"

      t.timestamps null: false
    end
  end
end
