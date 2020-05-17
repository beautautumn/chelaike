class AddIndexToNameForIntentionLevels < ActiveRecord::Migration
  def change
    add_index :intention_levels, :name
  end
end
