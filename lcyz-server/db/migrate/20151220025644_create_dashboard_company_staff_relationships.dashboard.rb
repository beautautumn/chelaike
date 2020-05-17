# This migration comes from dashboard (originally 20151220025503)
class CreateDashboardCompanyStaffRelationships < ActiveRecord::Migration
  def change
    create_table :dashboard_company_staff_relationships, comment: "公司服务顾问关系表" do |t|

      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :staff_id, index: true, comment: "服务顾问ID"

      t.timestamps null: false
    end
  end
end
