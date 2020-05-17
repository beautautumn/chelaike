class AddSpecialOfferToCars < ActiveRecord::Migration
  def change
    add_column :cars, :is_special_offer, :boolean, index: true, default: false, comment: "是否特价"
  end
end
