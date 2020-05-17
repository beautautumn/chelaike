class AddPreparerIdToPrepareRecord < ActiveRecord::Migration
  def change
    add_column :prepare_records, :preparer_id, :integer, index: true, comment: "整备员ID"
  end
end
