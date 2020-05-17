class CreateEnumTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :enum_types do |t|
      t.string :name, comment: "枚举类型的名称"
      t.string :code, comment: "枚举类型的唯一编码"
      t.string :additional_info, comment: "枚举类型附加信息"

      t.timestamps
    end
  end
end
