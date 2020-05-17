class AddDefaultValueToDeviceNumbers < ActiveRecord::Migration
  def change
    change_column_default :users, :device_numbers, []
  end
end
