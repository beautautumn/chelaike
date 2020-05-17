class AddWaterMarkToAllianceCompany < ActiveRecord::Migration
  def change
    add_column :alliance_companies, :water_mark_position, :jsonb, comment: "水印位置"
    add_column :alliance_companies, :water_mark, :string, comment: "水印图片url"
  end
end
