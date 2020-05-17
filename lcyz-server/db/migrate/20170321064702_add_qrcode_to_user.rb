class AddQrcodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :qrcode_url, :string, comment: "二维码地址"
    add_column :users, :self_description, :text, comment: "自我介绍"
  end
end
