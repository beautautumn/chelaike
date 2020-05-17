class ChangeMiscToOtherForFinanceCarIncome < ActiveRecord::Migration
  def change
    rename_column :finance_car_incomes, :misc_cost_cents, :other_cost_cents
    rename_column :finance_car_incomes, :misc_profit_cents, :other_profit_cents
  end
end
