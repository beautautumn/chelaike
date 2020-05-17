class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers, comment: "客户" do |t|
      t.belongs_to :company, index: true, comment: "公司ID"
      t.string :name, comment: "姓名"
      t.string :mobile, comment: "联系电话"
      t.text :note, comment: "备注"
      t.string :province, comment: "省份"
      t.string :city, comment: "城市"

      t.timestamps null: false
    end
  end
end
