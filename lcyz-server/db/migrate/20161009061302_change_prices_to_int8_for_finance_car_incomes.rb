class ChangePricesToInt8ForFinanceCarIncomes < ActiveRecord::Migration
  def change
    change_column :finance_car_incomes, :payment_cents, :integer, limit: 8
    change_column :finance_car_incomes, :prepare_cost_cents, :integer, limit: 8
    change_column :finance_car_incomes, :handling_charge_cents, :integer, limit: 8
    change_column :finance_car_incomes, :commission_cents, :integer, limit: 8
    change_column :finance_car_incomes, :percentage_cents, :integer, limit: 8
    change_column :finance_car_incomes, :fund_cost_cents, :integer, limit: 8
    change_column :finance_car_incomes, :other_cost_cents, :integer, limit: 8
    change_column :finance_car_incomes, :receipt_cents, :integer, limit: 8
    change_column :finance_car_incomes, :other_profit_cents, :integer, limit: 8
    change_column :finance_car_incomes, :acquisition_price_cents, :integer, limit: 8
    change_column :finance_car_incomes, :closing_cost_cents, :integer, limit: 8
  end
end
