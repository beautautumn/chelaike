class AddSupportCountAndViewedCountToPublicPraiseRecords < ActiveRecord::Migration
  def change
    add_column :public_praise_records, :support_count, :integer, comment: "支持数"
    add_column :public_praise_records, :viewed_count, :integer, comment: "浏览数"

    add_index :public_praise_records, [:support_count, :viewed_count]
  end
end
