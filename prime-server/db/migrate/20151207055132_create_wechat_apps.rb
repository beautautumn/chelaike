class CreateWechatApps < ActiveRecord::Migration
  def change
    create_table :wechat_apps, comment: "微信应用" do |t|
      t.string :app_id, index: true, comment: "微信公众号app id"
      t.integer :company_id, index: true, comment: "公司id"
      t.string :user_name, index: true, comment: "微信公众号username"
      t.string :refresh_token, comment: "重置令牌的token"
      t.text :authorities, array: true, comment: "可操作的app权限"
      t.jsonb :menus, default: {}, comment: "菜单"

      t.timestamps null: false
    end
  end
end
