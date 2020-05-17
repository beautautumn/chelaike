class CreateAntQueenRecordHubs < ActiveRecord::Migration
  def change
    create_table :ant_queen_record_hubs , comment: "蚂蚁女王报告" do |t|
      t.string :vin
      t.string :car_brand, comment: "品牌"
      t.integer :car_brand_id, comment: "蚂蚁女王品牌id"
      t.integer :number_of_accidents, comment: "事故次数"
      t.date :last_time_to_shop, comment: "最后进店时间"
      t.integer :total_mileage, comment: "行驶的总公里数"
      t.string :notify_type, comment: "通知类型"
      t.datetime :notify_time, comment: "通知时间"
      t.string :notify_id, comment: "通知id"
      t.text :result_description, comment: "报告描述"
      t.json :result_images, comment: "报告图片"
      t.string :result_status, comment: "报告状态"
      t.datetime :gmt_create, comment: "此次订单创建的时间"
      t.datetime :gmt_finish, comment: "此次订单完成的时间"
      t.integer :query_id, commont: "最新的蚂蚁女王查询id"
      t.boolean :request_success, default: false, commont: "请求是否成功"

      t.json :car_info, comment: "报告描述"
      t.json :car_status, comment: "报告描述"
      t.json :query_text, comment: "查询信息"
      t.json :text_img_json, comment: "报告描述"
      t.json :text_contents_json, comment: "报告描述"


      t.timestamps null: false
    end
  end
end
