class ChangeBalanceType < ActiveRecord::Migration
  def change
    change_column :tokens, :balance, :decimal, precision: 12, scale: 2, default: 0
  end
end
