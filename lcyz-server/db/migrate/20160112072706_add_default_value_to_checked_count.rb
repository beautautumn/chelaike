class AddDefaultValueToCheckedCount < ActiveRecord::Migration
  def change
    change_column_default :intentions, :checked_count, 0
  end
end
