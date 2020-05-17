class AddPathQueryToDailyActiveRecord < ActiveRecord::Migration
  def change
    add_column :daily_active_records, :url_path, :string, comment: "请求的接口"
    add_column :daily_active_records, :url_query, :jsonb, comment: "请求的参数"
  end
end
