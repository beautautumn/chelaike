class AddSortToImages < ActiveRecord::Migration
  def change
    add_column :images, :sort, :integer, index: true, default: 0, comment: "排序"
  end
end
