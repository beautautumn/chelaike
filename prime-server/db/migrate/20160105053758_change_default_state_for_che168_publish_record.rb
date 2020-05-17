class ChangeDefaultStateForChe168PublishRecord < ActiveRecord::Migration
  def change
    change_column :che168_publish_records, :state, :string, default: "pending", comment: "发布状态"
    change_column :che168_publish_records, :publish_state, :string, default: "pending", comment: "che168车辆状态"
  end
end
