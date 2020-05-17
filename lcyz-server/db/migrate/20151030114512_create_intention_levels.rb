class CreateIntentionLevels < ActiveRecord::Migration
  def change
    create_table :intention_levels, comment: "意向级别" do |t|
      t.belongs_to :company, index: true, comment: "公司ID"
      t.string :name, comment: "名称"
      t.string :note, comment: "说明"
      t.datetime :deleted_at, comment: "删除时间"

      t.timestamps null: false
    end
  end
end
