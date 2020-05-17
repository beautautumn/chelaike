class AddTenantToFavoriesAndEnquiries < ActiveRecord::Migration[5.0]
  def change
    add_column :favorite_cars, :tenant_id, :integer, comment: "所属平台租户"
    add_column :enquiries, :tenant_id, :integer, comment: "所属平台租户"
  end
end
