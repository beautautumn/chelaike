class AddAllianceAssigneeIdToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :alliance_assignee_id, :integer, comment: "联盟用户ID"

    add_index :intentions, :alliance_assignee_id
  end
end
