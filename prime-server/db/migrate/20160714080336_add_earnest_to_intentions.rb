class AddEarnestToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :earnest, :boolean, default: false, index: true, comment: "是否已收意向金"
  end
end
