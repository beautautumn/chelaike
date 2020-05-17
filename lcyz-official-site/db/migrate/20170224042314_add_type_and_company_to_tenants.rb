class AddTypeAndCompanyToTenants < ActiveRecord::Migration[5.0]
  def change
    remove_column :site_configurations, :company_id, :integer, index: true, comment: "对应车来客公司"
    add_column :tenants, :company_id, :integer, index: true, comment: "对应车来客公司"
    add_column :tenants, :tenant_type, :string, comment: "租户类型： 商家、联盟"
  end
end
