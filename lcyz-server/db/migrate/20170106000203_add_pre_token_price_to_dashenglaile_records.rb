class AddPreTokenPriceToDashenglaileRecords < ActiveRecord::Migration
  def change
    add_column :dashenglaile_records, :pre_token_price,
               :decimal, precision: 8, scale: 2,
               comment: "原价"
  end
end
