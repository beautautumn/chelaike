class AddMacAddressAndSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :settings, :jsonb, default: {}, comment: "设置"
    add_column :users, :mac_address, :string, comment: "MAC地址"
  end
end
