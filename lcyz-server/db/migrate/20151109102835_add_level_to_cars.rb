class AddLevelToCars < ActiveRecord::Migration
  def change
    add_column :cars, :level, :string, comment: "车辆等级"
  end
end
