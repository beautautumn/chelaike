class AddCurrentDeviceNumberToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column  :easy_loan_users, :current_device_number, :string,  comment: "车融易当前登录设备号码"
  end
end
