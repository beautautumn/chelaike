class CreateLoginHistories < ActiveRecord::Migration
  def change
    create_table :login_histories do |t|
      t.belongs_to :user, index: true, comment: "用户ID"
      t.belongs_to :company, index: true, comment: "公司ID"
      t.string :ip, comment: "IP地址"
      t.string :user_agent, comment: "UserAgent"
      t.string :mac_address, comment: "MAC地址"
      t.string :device_number, comment: "APP设备号"

      t.timestamps null: false
    end
  end
end
