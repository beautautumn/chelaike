class AddCrossShopAuthoritiesToUsers < ActiveRecord::Migration
  def migrate(dir)
    super

    Company.includes(:shops).find_each do |company|
      case company.shops.size
      when 0
        shop = company.shops.create(name: company.name)
      when 1
        shop = company.shops.last
      else
        shop = company.shops.find_or_create_by(name: "默认分店")
      end

      company.users.where(shop_id: nil).update_all(shop_id: shop.id)
      company.cars.where(shop_id: nil).update_all(shop_id: shop.id)
    end
  end

  def change
    add_column :users, :cross_shop_authorities, :text, array: true, comment: "跨店权限", default: []
  end
end
