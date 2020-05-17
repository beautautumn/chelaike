class AddRequestSentAtToMaintenanceRecordHubs < ActiveRecord::Migration
  def change
    add_column :maintenance_record_hubs, :request_sent_at, :datetime, comment: "发送给车鉴定的请求时间"
    add_column :ant_queen_record_hubs, :request_sent_at, :datetime, comment: "发送给蚂蚁女王的请求时间"
  end
end
