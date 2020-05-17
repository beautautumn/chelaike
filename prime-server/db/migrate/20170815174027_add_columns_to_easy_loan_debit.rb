class AddColumnsToEasyLoanDebit < ActiveRecord::Migration
  def change
    add_column :easy_loan_debits, :cash_turnover_rate, :decimal, comment: "资金周转率"
    add_column :easy_loan_debits, :car_gross_profit_rate, :decimal, comment: "月利润率"
  end
end
