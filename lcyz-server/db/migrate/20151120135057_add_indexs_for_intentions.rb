class AddIndexsForIntentions < ActiveRecord::Migration
  def change
    add_index :intentions, :interviewed_time
    add_index :intentions, :processing_time
  end
end
