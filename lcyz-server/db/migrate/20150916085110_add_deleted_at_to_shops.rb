class AddDeletedAtToShops < ActiveRecord::Migration
  def change
    add_column :shops, :deleted_at, :datetime, comment: "伪删除时间"
  end
end
