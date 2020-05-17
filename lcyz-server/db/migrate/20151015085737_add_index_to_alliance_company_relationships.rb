class AddIndexToAllianceCompanyRelationships < ActiveRecord::Migration
  def change
    add_index :alliance_company_relationships, :company_id
    add_index :alliance_company_relationships, :alliance_id
  end
end
