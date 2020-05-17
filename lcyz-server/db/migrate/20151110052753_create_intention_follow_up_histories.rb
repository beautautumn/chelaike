class CreateIntentionFollowUpHistories < ActiveRecord::Migration
  def change
    create_table :intention_follow_up_histories, comment: "意向跟进历史" do |t|
      t.belongs_to :intention, index: true, comment: "意向ID"
      t.string :state, comment: "跟进状态/结果"
      t.datetime :due_time, index: true, comment: "接待时间"
      t.boolean :checked, default: false, comment: "是否到店/是否评估实车"
      t.text :note, comment: "说明"

      t.timestamps null: false
    end
  end
end
