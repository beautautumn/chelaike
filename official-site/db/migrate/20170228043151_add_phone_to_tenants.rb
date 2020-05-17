class AddPhoneToTenants < ActiveRecord::Migration[5.0]
  def change
    add_column :tenants, :phone, :string, comment: "租户的手机，登录用"
  end
end
