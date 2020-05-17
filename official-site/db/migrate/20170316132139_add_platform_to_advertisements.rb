class AddPlatformToAdvertisements < ActiveRecord::Migration[5.0]
  def change
    add_column :advertisements, :platform, :string, comment: "平台类型(移动/桌面)"
  end
end
