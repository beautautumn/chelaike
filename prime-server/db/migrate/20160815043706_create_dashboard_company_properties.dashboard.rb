# This migration comes from dashboard (originally 20160815023941)
class CreateDashboardCompanyProperties < ActiveRecord::Migration
  def change
    create_table :dashboard_company_properties, comment: "公司运营管理属性表" do |t|
      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :staff_id, index: true, comment: "服务顾问ID"

      t.timestamps null: false
    end
  end
end