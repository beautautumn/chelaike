class AddInfoToWechatApps < ActiveRecord::Migration
  def change
    add_column :wechat_apps, :nick_name, :string, comment: "授权方昵称"
    add_column :wechat_apps, :alias, :string, comment: "授权方公众号所设置的微信号"
    add_column :wechat_apps, :menus_state, :string, comment: "菜单存储状态"
    add_column :wechat_apps, :head_img, :string, limit: 500
    add_column :wechat_apps, :service_type_info, :integer, comment: "公众号类型"
    add_column :wechat_apps, :verify_type_info, :integer, comment: "认证类型"
    add_column :wechat_apps, :business_info, :jsonb, comment: "功能的开通状况（0代表未开通，1代表已开通）"
    add_column :wechat_apps, :qrcode_url, :string, limit: 500, comment: " 二维码图片的URL"

    remove_columns :wechat_apps, :menus
    add_column :wechat_apps, :menus, :jsonb, array: true, default: []
  end
end
