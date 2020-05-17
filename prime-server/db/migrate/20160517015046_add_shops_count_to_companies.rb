class AddShopsCountToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :shops_count, :integer, default: 0
  end
end
