class AddSystemNameToCars < ActiveRecord::Migration
  def change
    add_column :cars, :system_name, :string, comment: "车辆系统名"
  end
end
