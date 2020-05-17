class CreateAllianceChannels < ActiveRecord::Migration
  def change
    create_table :alliance_channels, comment: "联盟公司意向渠道" do |t|
      t.integer  :company_id,              comment: "公司ID"
      t.string   :name,                    comment: "名称"
      t.text     :note,                    comment: "备注"
      t.datetime :deleted_at,              comment: "删除时间"
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.timestamps null: false
    end
  end
end
