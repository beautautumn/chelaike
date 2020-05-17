class AddAllianceCompanyIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :alliance_company_id, :integer, comment: "所属品牌联盟的联盟公司"

    add_index :companies, :alliance_company_id
  end
end
