class CreateIntentionPushHistories < ActiveRecord::Migration
  def change
    create_table :intention_push_histories, comment: "意向跟进历史" do |t|
      t.integer :intention_id, index: true, comment: "意向ID"
      t.datetime :next_pushed_at, index: true, comment: "下次跟进时间"
      t.text :push_note, comment: "跟进说明"

      t.timestamps null: false
    end
  end
end
