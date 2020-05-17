class ChangeCarConfigurationLoanDataDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:car_configurations, :loan_data, {})
  end
end
