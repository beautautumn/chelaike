class CreateDashenglaileRecords < ActiveRecord::Migration
  def change
    create_table  :dashenglaile_records, comment: "大圣来了记录" do |t|
      t.integer   :company_id, index: true,                       comment: "公司ID"
      t.integer   :car_id, index: true,                           comment: "车辆ID"
      t.integer   :shop_id, index: true,                          comment: "店铺ID"
      t.string    :vin,                                           comment: "vin码"
      t.string    :engine_num,                                    comment: "发动机号"
      t.integer   :car_brand_id,                                  comment: "大圣来了品牌 ID"
      t.string    :state,                                         comment: "查询状态"
      t.integer   :last_fetch_by, index: true,                    comment: "最后查询的用户ID"
      t.string    :user_name,                                     comment: "最后查询的用户名"
      t.datetime  :last_fetch_at,                                 comment: "最后查询的时间"
      t.integer   :dashenglaile_record_hub_id, index: true,       comment: "所属报告"
      t.integer   :last_dashenglaile_record_hub_id, index: true,  comment: "最近更新的报告"
      t.decimal   :token_price, precision: 8, scale: 2,           comment: "查询价格"
      t.string    :vin_image,                                     comment: "vin码图片地址"

      t.timestamps null: false
    end
  end
end
