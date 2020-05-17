class AddLoanToFinanceCarIncome < ActiveRecord::Migration
  def change
    add_column :finance_car_incomes,
               :loan_cents,
               :integer,
               comment: "单车融资数额"
  end
end
