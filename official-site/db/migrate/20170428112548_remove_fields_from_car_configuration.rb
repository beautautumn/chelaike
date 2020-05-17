class RemoveFieldsFromCarConfiguration < ActiveRecord::Migration[5.0]
  def change
    remove_column :car_configurations, :down_payments
    remove_column :car_configurations, :interest_rate
    remove_column :car_configurations, :loan_term
  end
end
