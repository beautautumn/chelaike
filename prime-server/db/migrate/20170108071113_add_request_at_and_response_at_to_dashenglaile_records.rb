class AddRequestAtAndResponseAtToDashenglaileRecords < ActiveRecord::Migration
  def change
    add_column :dashenglaile_records, :request_at, :datetime, comment: "请求时间"
    add_column :dashenglaile_records, :response_at, :datetime, comment: "返回时间"

  end
end
