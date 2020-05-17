class CreateCustomerCreationInfoDimensions < ActiveRecord::Migration
  def change
    create_table :customer_creation_info_dimensions, comment: "客户创建信息维度" do |t|
      t.string :source, comment: "客户创建源"
      t.datetime :created_at, comment: "客户创建日期"
      t.integer :created_at_year, comment: "客户创建日期所在年份"
      t.integer :created_at_month, comment: "客户创建日期所在月份"

      t.timestamps null: false
    end
  end
end
