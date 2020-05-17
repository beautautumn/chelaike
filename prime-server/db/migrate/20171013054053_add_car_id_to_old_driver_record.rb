class AddCarIdToOldDriverRecord < ActiveRecord::Migration
  def change
    add_column :old_driver_records, :car_id, :integer, comment: "车辆ID"
  end
end
