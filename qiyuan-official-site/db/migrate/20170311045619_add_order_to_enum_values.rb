class AddOrderToEnumValues < ActiveRecord::Migration[5.0]
  def change
    add_column :enum_values, :order, :integer, comment: "枚举排序值"
  end
end
