class RedefineIntentionNoteFromIntentions < ActiveRecord::Migration
  def change
    remove_column :intentions, :intention_note
    add_column :intentions, :intention_note, :text, comment: "意向描述"
  end
end
