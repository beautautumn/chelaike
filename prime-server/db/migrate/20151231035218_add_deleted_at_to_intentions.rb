class AddDeletedAtToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :deleted_at, :datetime, comment: "删除时间"
  end
end
