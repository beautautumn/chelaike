class AddStyleNameToIntention < ActiveRecord::Migration
  def change
    add_column :intentions, :style_name, :string, comment: "出售车辆车款名称"
  end
end
