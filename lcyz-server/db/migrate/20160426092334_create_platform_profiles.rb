class CreatePlatformProfiles < ActiveRecord::Migration
  def change
    create_table :platform_profiles do |t|
      t.integer :company_id, comment: "公司ID"
      t.jsonb :data, comment: "账号信息"

      t.timestamps null: false
    end
  end
end
