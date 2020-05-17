class CreatePublisherProfiles < ActiveRecord::Migration
  def change
    create_table :publisher_profiles, comment: "发布者信息" do |t|

      t.integer :company_id, index: true, comment: "公司ID"
      t.string :type, comment: "单表继承类型"
      t.jsonb :data, default: {}, comment: "账号信息"

      t.timestamps null: false
    end
  end
end
