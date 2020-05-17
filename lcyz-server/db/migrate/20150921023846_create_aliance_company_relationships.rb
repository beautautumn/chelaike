class CreateAlianceCompanyRelationships < ActiveRecord::Migration
  def change
    create_table :aliance_company_relationships, comment: "联盟公司关系表" do |t|

      t.integer :company_id, comment: "公司ID"
      t.integer :aliance_id, comment: "联盟ID"
      t.datetime :deleted_at, comment: "伪删除时间"

      t.timestamps null: false
    end
  end
end
