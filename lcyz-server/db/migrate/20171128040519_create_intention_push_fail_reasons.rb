class CreateIntentionPushFailReasons < ActiveRecord::Migration
  def change
    create_table :intention_push_fail_reasons, comment: "意向跟进失败原因" do |t|
      t.integer :company_id, comment: "公司id"
      t.text :note, comment: "备注"
      t.string :name, comment: "失败原因名"

      t.timestamps null: false
    end
  end
end
