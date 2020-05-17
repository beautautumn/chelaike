class AddqrCodeToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :qr_code_url, :string
  end
end
