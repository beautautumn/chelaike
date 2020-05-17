class AddDeviceNumbersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_numbers, :text, array: true, comment: "App设备号"
  end
end
