class AddDefaultValueForStatesStatistic < ActiveRecord::Migration
  def change
    change_column_default :cars, :states_statistic, {}
  end
end
