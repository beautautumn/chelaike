class AddLabelsToDashboardCompanyProperties < ActiveRecord::Migration
  def change
    add_column :dashboard_company_properties, :labels, :jsonb, default: [], array: true, comment: "车商标签"
  end
end
