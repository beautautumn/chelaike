class AddYouhaosudaTokenToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :youhaosuda_shop_token, :string, comment: "友好速搭商铺Token"
  end
end
