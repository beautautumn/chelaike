class AddColumnssToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :industry_rating, :decimal, default: 3.0, comment: "默认行业风评等级"
    add_column :companies, :assets_debts_rating, :decimal, default: 0.6, comment: "默认资产负债率"
  end
end
