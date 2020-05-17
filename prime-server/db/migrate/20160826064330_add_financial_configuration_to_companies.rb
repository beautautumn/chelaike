class AddFinancialConfigurationToCompanies < ActiveRecord::Migration
  def change
    unless column_exists?(:companies, :financial_configuration)
      add_column :companies, :financial_configuration, :jsonb, default: {}, comment: "财务设置"
    end
  end
end
