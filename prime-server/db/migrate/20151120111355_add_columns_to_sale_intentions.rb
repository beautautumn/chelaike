class AddColumnsToSaleIntentions < ActiveRecord::Migration
  def change
    add_column :sale_intentions, :province, :string, comment: "省"
    add_column :sale_intentions, :city, :string, comment: "城市"
    add_column :sale_intentions, :expected_price_cents, :bigint, comment: "期望价格"
  end
end
