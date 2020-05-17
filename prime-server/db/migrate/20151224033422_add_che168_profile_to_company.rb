class AddChe168ProfileToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :che168_profile, :jsonb, default: {}, comment: "che168信息"
  end
end
