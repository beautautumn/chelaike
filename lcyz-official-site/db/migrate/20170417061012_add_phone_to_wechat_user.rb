class AddPhoneToWechatUser < ActiveRecord::Migration[5.0]
  def change
    add_column :wechat_users, :phone, :string, comment: "微信用户手机号"
  end
end
