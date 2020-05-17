class AddRequestSuccessToDashenglaileRecordHubs < ActiveRecord::Migration
  def change
    add_column :dashenglaile_record_hubs, :request_success, :boolean, default: "false", comment: "请求是否成功"
  end
end
