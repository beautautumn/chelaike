class AddConsignedAtToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :consigned_at, :date, comment: "寄卖时间"
  end
end
