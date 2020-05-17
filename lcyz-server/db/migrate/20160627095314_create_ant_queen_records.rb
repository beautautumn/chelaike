class CreateAntQueenRecords < ActiveRecord::Migration
  def change
    create_table :ant_queen_records, comment: "蚂蚁女王记录" do |t|
      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :car_id, index: true, comment: "车辆ID"
      t.integer :shop_id, index: true, comment: "店铺ID"
      t.string :vin
      t.string :state
      t.integer :last_fetch_by, comment: "最后查询的用户ID"
      t.string :user_name, comment: "最后查询的用户名"
      t.timestamp :last_fetch_at, comment: "最后查询的时间"
      t.integer :ant_queen_record_hub_id
      t.integer :last_ant_queen_record_hub_id, commont: "用来记录更新前的id"

      t.timestamps null: false
    end
  end
end
