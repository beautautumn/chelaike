class CreateWechatUsers < ActiveRecord::Migration
  def change
    create_table :wechat_users, comment: "微信用户" do |t|

      t.string :open_id, index: true, comment: "微信用户open id"
      t.integer :wechat_app_id, index: true, comment: "微信应用ID"
      t.boolean :subscribed, comment: "用户是否关注该应用"
      t.string :nick_name, comment: "微信昵称"
      t.string :gender, comment: "用户性别"
      t.string :city, comment: "所在城市"
      t.string :province, comment: "所在省份"
      t.string :country, comment: "所在国家"
      t.string :avatar, comment: "头像"
      t.string :note, comment: "备注"
      t.integer :group_code, comment: "所在分组ID"

      t.timestamps null: false
    end
  end
end
