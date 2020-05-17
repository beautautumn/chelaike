class AddTenantIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tenant_id, :integer, comment: "所属平台租户"
  end
end
