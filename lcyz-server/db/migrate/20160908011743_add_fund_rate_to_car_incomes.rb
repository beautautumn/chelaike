class AddFundRateToCarIncomes < ActiveRecord::Migration
  def change
    add_column :finance_car_incomes,
               :fund_rate,
               :decimal,
               comment: "单车对应的资金利率"
  end
end
