class AddUnionidToWechatUser < ActiveRecord::Migration
  def change
    add_column :wechat_users, :unionid, :string
  end
end
