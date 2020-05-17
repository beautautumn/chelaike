class AddCacheCounterColumnToAlliancesAndCompanies < ActiveRecord::Migration
  def migrate(dir)
    super

    Alliance.pluck(:id).each do |id|
      Alliance.reset_counters(id, :companies)
    end

    Company.pluck(:id).each do |id|
      Company.reset_counters(id, :alliances)
    end
  end

  def change
    add_column :alliances, :companies_count, :integer, comment: "公司数量"
    add_column :companies, :alliances_count, :integer, comment: "联盟数量"
    add_column :companies, :cars_count, :integer, comment: "车辆数量"
    add_column :companies, :avatar, :string, comment: "公司头像"
  end
end
