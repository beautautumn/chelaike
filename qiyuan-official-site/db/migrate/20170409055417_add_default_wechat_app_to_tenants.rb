class AddDefaultWechatAppToTenants < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :default_wechat_app_id, :integer, comment: "默认微信公众号 ID"

  end
end
