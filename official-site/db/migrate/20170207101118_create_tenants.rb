class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants, comment: "平台租户，对应每个商家" do |t|
      t.string :name, comment: "商家名"
      t.string :subdomain, comment: "二级子域名"
      t.string :tld, comment: "顶级域名"
      t.string :app_secret, comment: "对应车来客里的app_secret"

      t.timestamps
    end
  end
end
