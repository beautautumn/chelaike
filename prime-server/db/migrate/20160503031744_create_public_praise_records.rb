class CreatePublicPraiseRecords < ActiveRecord::Migration
  def change
    create_table :public_praise_records, comment: "二手车之家口碑记录" do |t|
      t.integer :sumup_id, index: true
      t.string :link, index: true, comment: "抓取链接"
      t.string :level, index: true, comment: "级别"
      t.string :most_satisfied, comment: "最满意的"
      t.string :least_satisfied, comment: "最不满意的"
      t.string :logo, comment: "用户Logo"
      t.string :username, comment: "用户名"
      t.jsonb :content, comment: "内容"

      t.timestamps null: false
    end
  end
end
