class AddProvinceCityToShops < ActiveRecord::Migration
  def change
    add_column :shops, :province, :string, comment: "所在省份"
    add_column :shops, :city, :string, comment: "所在城市"
  end
end
