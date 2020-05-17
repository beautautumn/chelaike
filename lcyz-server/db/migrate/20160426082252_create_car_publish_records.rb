class CreateCarPublishRecords < ActiveRecord::Migration
  def change
    create_table :car_publish_records do |t|

      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :car_id, index: true, comment: "发布车辆ID"
      t.integer :user_id, index: true, comment: "发布者ID"
      t.integer :published_id, index: true, comment: "对应平台车辆ID"
      t.string :state, default: "processing", comment: "发布状态"
      t.string :error_message, comment: "错误信息"
      t.string :publish_state, comment: "车辆在对应平台的状态"
      t.string :type, comment: "STI"

      t.timestamps null: false
    end
  end
end
