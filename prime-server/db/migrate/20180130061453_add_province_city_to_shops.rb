class AddProvinceCityToShops < ActiveRecord::Migration
  def change
    add_column :shops, :province, :string, comment: "所在省份"
    add_column :shops, :city, :string, comment: "所在城市"

    Shop.find_each(batch_size: 200) do |shop|
      company = shop.company
      shop.update_columns(
        province: company.try(:province),
        city: company.try(:city)
      )
    end
  end
end
