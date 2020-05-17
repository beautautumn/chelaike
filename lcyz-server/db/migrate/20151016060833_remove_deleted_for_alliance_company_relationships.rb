class RemoveDeletedForAllianceCompanyRelationships < ActiveRecord::Migration
  def change
    remove_column :alliance_company_relationships, :deleted_at
  end
end
