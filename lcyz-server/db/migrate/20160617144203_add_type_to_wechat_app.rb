class AddTypeToWechatApp < ActiveRecord::Migration
  def change
    remove_column :wechat_apps, :company_id
    add_reference :wechat_apps, :company, polymorphic: true, index: true
  end
end
