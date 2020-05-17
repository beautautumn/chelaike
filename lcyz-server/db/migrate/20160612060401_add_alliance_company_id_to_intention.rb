class AddAllianceCompanyIdToIntention < ActiveRecord::Migration
  def change
    add_column :intentions, :alliance_company_id, :integer
    add_index :intentions, :alliance_company_id
  end
end
