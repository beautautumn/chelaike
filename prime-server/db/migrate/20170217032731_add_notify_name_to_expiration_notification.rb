class AddNotifyNameToExpirationNotification < ActiveRecord::Migration
  def change
    add_column :expiration_notifications, :notify_name, :string, comment: "通知的名字"
  end
end
