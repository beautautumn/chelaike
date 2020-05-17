class AddIsOnsaleToCars < ActiveRecord::Migration
  def change
    add_column :cars, :is_onsale, :boolean, default: false, comment: "车辆是否特卖"
    add_column :cars, :onsale_price_cents, :bigint, comment: "特卖价格"
    add_column :cars, :onsale_description, :string, comment: "特卖描述"
  end
end
