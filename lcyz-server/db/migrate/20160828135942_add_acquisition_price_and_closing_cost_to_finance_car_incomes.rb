class AddAcquisitionPriceAndClosingCostToFinanceCarIncomes < ActiveRecord::Migration
  def change
    unless column_exists?(:finance_car_incomes, :acquisition_price_cents)
      add_column :finance_car_incomes,
                 :acquisition_price_cents,
                 :integer,
                 comment: "收购价格"
    end
    unless column_exists?(:finance_car_incomes, :closing_cost_cents)
      add_column :finance_car_incomes,
                 :closing_cost_cents,
                 :integer,
                 comment: "成交价格"
    end
  end
end
