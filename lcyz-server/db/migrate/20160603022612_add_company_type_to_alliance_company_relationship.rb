class AddCompanyTypeToAllianceCompanyRelationship < ActiveRecord::Migration
  def change
    add_column :alliance_company_relationships, :company_type, :string, comment: "polymorphic"
  end
end
