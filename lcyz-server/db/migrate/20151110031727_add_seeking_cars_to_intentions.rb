class AddSeekingCarsToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :seeking_cars, :text, array: true, default: [], comment: "求购车辆"
  end
end
