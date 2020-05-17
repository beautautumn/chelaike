class AddSloganToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :slogan, :text, comment: "宣传语"
  end
end
