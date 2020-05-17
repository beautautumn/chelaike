class AddAppSecretToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :app_secret, :string, index: true, comment: "商家secret"
  end
end
