class AddNicknameToAllianceCompanyRelationship < ActiveRecord::Migration
  def change
    add_column :alliance_company_relationships, :nickname, :string, comment: "公司在联盟中的昵称"
  end
end
