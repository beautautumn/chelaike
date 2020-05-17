class AddNotificationsToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :annual_inspection_notify_date, :date, comment: "年审到期提醒日期"
    add_column :intentions, :insurance_notify_date, :date, comment: "保险到期提醒日期"
    add_column :intentions, :mortgage_notify_date, :date, comment: "按揭到期提醒日期"
  end
end
