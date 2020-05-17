class AddOpenAllianceToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :open_alliance_id, :integer, index: true, comment: "开放联盟ID"
  end
end
