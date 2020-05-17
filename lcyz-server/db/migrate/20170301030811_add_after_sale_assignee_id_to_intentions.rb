class AddAfterSaleAssigneeIdToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :after_sale_assignee_id, :integer, comment: "服务归属人ID"
  end
end
