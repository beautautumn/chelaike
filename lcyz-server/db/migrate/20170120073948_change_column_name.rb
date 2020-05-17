class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :intentions, :alliance_intention_id, :alliance_intention_level_id
  end
end
