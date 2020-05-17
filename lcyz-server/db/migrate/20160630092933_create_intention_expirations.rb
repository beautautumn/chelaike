class CreateIntentionExpirations < ActiveRecord::Migration
  def change
    create_table :intention_expirations, comment: "意向过期时间" do |t|
      t.references :company, index: true, foreign_key: {on_delete: :cascade}, comment: "公司ID"
      t.integer :expiration_days, null: false, comment: "过期天数"
      t.text :note, comment: "备注"

      t.timestamps null: false
    end
  end
end
