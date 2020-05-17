class AddIndexToOnlinePriceCents < ActiveRecord::Migration
  def change
    add_index :cars, :online_price_cents
  end
end
