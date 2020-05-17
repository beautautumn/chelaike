class AddLimitLimitationToIntentionLevels < ActiveRecord::Migration
  def change
    add_column :intention_levels, :time_limitation, :integer, default: 0, comment: "时间限制"
  end
end
