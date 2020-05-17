class CreateAllianceAuthorityRoles < ActiveRecord::Migration
  def change
    create_table :alliance_authority_roles, comment: "联盟公司的权限角色" do |t|
      t.integer  :alliance_company_id
      t.string   :name,                                               comment: "名称"
      t.text     :authorities, default: [],              array: true, comment: "权限"
      t.text     :note,                                               comment: "备注"

      t.timestamps null: false
    end
  end
end
