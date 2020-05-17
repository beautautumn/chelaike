class AddAlliancesCountToAllianceCompanies < ActiveRecord::Migration
  def change
    add_column :alliance_companies, :alliances_count, :integer, comment: "联盟数量"
  end
end
