class CreateAppVersionCompanyRelationships < ActiveRecord::Migration
  def change
    create_table :app_version_company_relationships, comment: "app版本公司关系表" do |t|

      t.integer :company_id, index: true, comment: "公司ID"
      t.integer :version_id, index: true, comment: "版本控制ID"

      t.timestamps null: false
    end
  end
end
