class AddIndexToStateForIntentions < ActiveRecord::Migration
  def change
    add_index :intentions, :state
  end
end
