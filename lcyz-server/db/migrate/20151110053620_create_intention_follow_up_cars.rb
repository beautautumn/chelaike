class CreateIntentionFollowUpCars < ActiveRecord::Migration
  def change
    create_table :intention_follow_up_cars, comment: "看过的车辆" do |t|
      t.belongs_to :intention, index: true, comment: "意向ID"
      t.belongs_to :intention_follow_up_history, comment: "意向跟进历史ID"
      t.belongs_to :car, index: true, comment: "车辆ID"

      t.timestamps null: false
    end

    add_index :intention_follow_up_cars, :intention_follow_up_history_id, name: :intention_follow_up_cars_history_id
  end
end
