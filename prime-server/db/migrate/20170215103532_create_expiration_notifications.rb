class CreateExpirationNotifications < ActiveRecord::Migration
  def change
    create_table :expiration_notifications, comment: "服务到期提醒" do |t|
      t.string :notify_type, comment: "通知类型"
      t.integer :associated_id, comment: "关联记录ID"
      t.string :associated_type, comment: "关联记录类型"
      t.date :notify_date, comment: "提醒日期"
      t.date :setting_date, comment: "原记录里设置的时间"
      t.integer :user_id, comment: "要通知到的用户"
      t.integer :company_id, comment: "所属公司ID"
      t.boolean :actived, default: true, comment: "是否可用"

      t.timestamps null: false
    end
  end
end
