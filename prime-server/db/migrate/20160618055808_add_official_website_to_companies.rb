class AddOfficialWebsiteToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :official_website_url, :string, comment: "官网地址"
  end
end
