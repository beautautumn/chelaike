class AddEstimatedPriceToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :estimated_price_cents, :bigint, comment: "评估车价"
    add_column :intention_follow_up_histories, :estimated_price_cents, :bigint, comment: "评估车价"
  end
end
