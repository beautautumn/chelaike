class AddCurrentDeviceNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_device_number, :string, comment: "用户当前使用的手机设备号"
  end
end
