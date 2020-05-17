class AddStateToWechatApp < ActiveRecord::Migration
  def change
    add_column :wechat_apps, :state, :string, default: "enabled", comment: "应用状态"
  end
end
