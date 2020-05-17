# This migration comes from dashboard (originally 20151217073004)
class ChangeColumnsToStaff < ActiveRecord::Migration
  def change
    add_column :dashboard_staffs, :manager_id, :integer, index: true, comment: "所属主管ID"
    add_column :dashboard_staffs, :role, :string, index: true, comment: "角色"
    remove_column :dashboard_staffs, :authorities
  end
end
