class CreateEnumValues < ActiveRecord::Migration[5.0]
  def change
    create_table :enum_values do |t|
      t.string :name, comment: "枚举值字面名称"
      t.string :value, comment: "枚举值"
      t.string :additional_info, comment: "枚举值附加信息"
      t.references :enum_type, foreign_key: true, comment: "枚举类型"

      t.timestamps
    end
  end
end
