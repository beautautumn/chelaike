class AddShowSecondsToAds < ActiveRecord::Migration
  def change
    add_column :advertisements, :show_seconds, :integer, comment: "广告展示时长"
  end
end
