class AddActivetagToCompanyProperties < ActiveRecord::Migration
  def change
    add_column :dashboard_company_properties, :active_tag, :boolean, default: false, comment: "车商考核活跃标记"
  end
end
