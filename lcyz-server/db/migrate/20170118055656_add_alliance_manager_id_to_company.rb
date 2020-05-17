class AddAllianceManagerIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :alliance_manager_id, :integer, comment: "这家公司所对应的联盟管理公司ID"
  end
end
