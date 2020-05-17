class CreateDailyActiveRecords < ActiveRecord::Migration
  def change
    create_table :daily_active_records, comment: "统计用户日活" do |t|
      t.integer :user_id, comment: "user_id"
      t.string :request_ip, comment: "请求的来源IP"
      t.string :url, comment: "请求的地址"
      t.string :region, comment: "省份"
      t.string :city, comment: "城市"
      t.integer :company_id, comment: "用户所属店家的id"

      t.timestamps null: false
    end
  end
end
