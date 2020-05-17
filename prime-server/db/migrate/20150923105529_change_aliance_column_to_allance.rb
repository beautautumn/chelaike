class ChangeAlianceColumnToAllance < ActiveRecord::Migration
  def change
    rename_column :alliance_company_relationships, :aliance_id, :alliance_id
  end
end
