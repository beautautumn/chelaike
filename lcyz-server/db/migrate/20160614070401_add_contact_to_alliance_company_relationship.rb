class AddContactToAllianceCompanyRelationship < ActiveRecord::Migration
  def change
    add_column :alliance_company_relationships, :contact, :string, comment: "联盟联系人，联盟后台使用"
    add_column :alliance_company_relationships, :contact_mobile, :string, comment: "联盟联系电话，联盟后台使用"
    add_column :alliance_company_relationships, :street, :string, comment: "联盟看车电话，联盟后台使用"
  end
end
