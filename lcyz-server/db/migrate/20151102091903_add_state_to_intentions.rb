class AddStateToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :state, :string, default: "pending", index: true, comment: "跟进状态"
  end
end
