class ChangePriceForIntentions < ActiveRecord::Migration
  def change
    remove_column :intentions, :price_cents

    add_column :intentions, :minimum_price_cents, :bigint, comment: "最低价格"
    add_column :intentions, :maximum_price_cents, :bigint, comment: "最高价格"
  end
end
