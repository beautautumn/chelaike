class ChangeSeekingCarsForIntention < ActiveRecord::Migration
  def change
    remove_column :intentions, :seeking_cars
    add_column :intentions, :seeking_cars, :json, array: true, default: [], comment: "求购车辆"
  end
end
