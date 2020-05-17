class AddNamePinyinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_letter, :string, index: true, comment: "拼音"
  end
end
