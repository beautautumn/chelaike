class CreatePriceTagTemplates < ActiveRecord::Migration
  def change
    create_table :price_tag_templates, comment: "价签模板" do |t|
      t.belongs_to :company, index: true, comment: "公司ID"
      t.string :name, comment: "模板名称"
      t.text :code, comment: "模板代码"
      t.string :backup, comment: "备份地址"

      t.timestamps null: false
    end
  end
end
