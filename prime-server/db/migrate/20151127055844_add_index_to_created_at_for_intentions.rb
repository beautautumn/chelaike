class AddIndexToCreatedAtForIntentions < ActiveRecord::Migration
  def change
    add_index :intentions, :created_at
  end
end
