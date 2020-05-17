class CreateEasyLoanSettings < ActiveRecord::Migration
  def change
    create_table :easy_loan_settings, comment: "车融易全局数据设置" do |t|
      t.string :phone,  comment: "联系电话"
      t.text :rate_category,  comment: "权重条目类型"
      t.decimal :rate_weight, comment: "权重"

      t.timestamps null: false
    end
  end
end
