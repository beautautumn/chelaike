class AddColumnsToIntentionsAndIntentionPushHistories < ActiveRecord::Migration
  def change
    add_column :intentions, :deposit_cents, :bigint, comment: "定金"
    add_column :intentions, :closing_cost_cents, :bigint, comment: "成交价格"
    add_column :intentions, :closing_car_id, :bigint, comment: "成交车辆ID"
    add_column :intentions, :closing_car_name, :string, comment: "成交车辆名称"

    add_column :intention_push_histories, :deposit_cents, :bigint, comment: "定金"
    add_column :intention_push_histories, :closing_cost_cents, :bigint, comment: "成交价格"
    add_column :intention_push_histories, :closing_car_id, :bigint, comment: "成交车辆ID"
    add_column :intention_push_histories, :closing_car_name, :string, comment: "成交车辆名称"
  end
end
