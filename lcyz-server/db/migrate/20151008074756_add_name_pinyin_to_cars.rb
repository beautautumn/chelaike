class AddNamePinyinToCars < ActiveRecord::Migration
  def change
    add_column :cars, :name_pinyin, :string, index: true, comment: "车辆名称拼音"
  end
end
