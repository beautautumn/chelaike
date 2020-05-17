class ChangeCarFeesAmountCentsToInt8 < ActiveRecord::Migration
  def change
    change_column :finance_car_incomes, :loan_cents, :integer, limit: 8
    change_column :finance_car_fees, :amount_cents, :integer, limit: 8
  end
end
