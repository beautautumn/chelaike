class CreateChe168PublishRecords < ActiveRecord::Migration
  def change
    create_table :che168_publish_records, comment: "che168发布记录" do |t|

      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :car_id, index: true, comment: "发布车辆ID"
      t.integer :user_id, index: true, comment: "发布者ID"
      t.integer :che168_id, index: true, comment: "che168对应车辆ID"
      t.string :state, default: "processing", comment: "发布状态"
      t.string :error_message, comment: "错误信息"
      t.text :command, comment: "发布命令记录"

      t.timestamps null: false
    end
  end
end
