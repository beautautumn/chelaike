class ChangeAlianceToAlliance < ActiveRecord::Migration
  def change
    rename_table :aliances, :alliances
    rename_table :aliance_company_relationships, :alliance_company_relationships
  end
end

