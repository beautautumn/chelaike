class CreateWechatApps < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_apps, comment: "微信应用" do |t|
      t.string :app_id, index: true, comment: "微信公众号app id"
      t.integer :tenant_id, index: true, comment: "租户 id"
      t.string :user_name, index: true, comment: "微信公众号username"
      t.string :refresh_token, comment: "重置令牌的token"
      t.text :authorities, array: true, comment: "可操作的app权限"

      t.string :nick_name, comment: "授权方昵称"
      t.string :alias, comment: "授权方公众号所设置的微信号"
      t.string :menus_state, comment: "菜单存储状态"
      t.string :head_img, limit: 500
      t.integer :service_type_info, comment: "公众号类型"
      t.integer :verify_type_info, comment: "认证类型"
      t.jsonb :business_info, comment: "功能的开通状况（0代表未开通，1代表已开通）"
      t.string :qrcode_url, limit: 500, comment: " 二维码图片的URL"
      t.string :state, default: "enabled", comment: "应用状态"

      t.timestamps null: false
    end
  end
end
