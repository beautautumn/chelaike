class AddFieldsToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :assigned_at, :datetime, comment: "分配给车商的时间"
    add_column :intentions, :in_shop_at, :datetime, comment: "客户到店时间"
  end
end
