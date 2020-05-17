class AddConventionToAlliances < ActiveRecord::Migration
  def change
    unless column_exists?(:alliances, :convention)
      add_column :alliances, :convention, :text, comment: "联盟公约"
    end
  end
end
