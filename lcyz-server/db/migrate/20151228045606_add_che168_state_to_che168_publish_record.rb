class AddChe168StateToChe168PublishRecord < ActiveRecord::Migration
  def change
    add_column :che168_publish_records, :publish_state, :string, default: "reviewing", comment: "che168车辆状态"
    add_column :che168_publish_records, :publish_message, :string, comment: "che168车辆状态信息"
  end
end
