class RemoveCompanyTypeFromAllianceCompanyRelationship < ActiveRecord::Migration
  def change
    remove_column :alliance_company_relationships, :company_type, :string
  end
end
