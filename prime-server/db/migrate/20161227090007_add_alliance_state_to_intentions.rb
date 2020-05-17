class AddAllianceStateToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :alliance_state, :string, comment: "联盟意向状态"
  end
end
