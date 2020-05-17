class AddQrcodeToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :qrcode, :string, comment: "商家二维码"
    add_column :companies, :banners, :string, array: true, comment: "网站Banners"
  end
end
