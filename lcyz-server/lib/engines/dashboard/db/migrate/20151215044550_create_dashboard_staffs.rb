class CreateDashboardStaffs < ActiveRecord::Migration
  def change
    create_table :dashboard_staffs, comment: "员工表" do |t|
      t.string :phone, comment: "员工手机号"
      t.string :name, comment: "员工姓名"
      t.string :state, default: "enabled", comment: "员工状态"
      t.string :authorities, array: true, comment: "员工权限"

      t.timestamps null: false
    end
  end
end
