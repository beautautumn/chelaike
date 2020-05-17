class CreateAllianceAuthorityRoleRelationships < ActiveRecord::Migration
  def change
    create_table :alliance_authority_role_relationships, comment: "联盟公司角色--用户关联表" do |t|
      t.integer :authority_role_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
