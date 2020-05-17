class CreateWechatUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_users, comment: "微信用户" do |t|
      t.string :nick_name, comment: "微信昵称"
      t.string :gender, comment: "用户性别"
      t.string :city, comment: "所在城市"
      t.string :province, comment: "所在省份"
      t.string :country, comment: "所在国家"
      t.string :avatar, comment: "头像"
      t.string :note, comment: "备注"
      t.string :union_id, comment: "Union ID"

      t.timestamps null: false
    end
  end
end
