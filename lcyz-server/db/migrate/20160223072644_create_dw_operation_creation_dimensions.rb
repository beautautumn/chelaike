class CreateDwOperationCreationDimensions < ActiveRecord::Migration
  def change
    create_table :dw_operation_creation_dimensions, comment: "操作历史创建维度" do |t|
      t.string :targetable_type, comment: "操作历史多态类型"
      t.string :operation_created_at, comment: "操作历史创建时间"
      t.string :operation_created_at_year, comment: "操作历史创建时间所在年份"
      t.string :operation_created_at_month, comment: "操作历史创建时间所在月份"

      t.timestamps null: false
    end
  end
end
