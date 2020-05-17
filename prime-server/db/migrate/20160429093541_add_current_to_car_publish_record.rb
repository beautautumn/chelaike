class AddCurrentToCarPublishRecord < ActiveRecord::Migration
  def change
    add_column :car_publish_records, :current, :boolean, default: false, comment: "是否是当前的记录"
  end
end
