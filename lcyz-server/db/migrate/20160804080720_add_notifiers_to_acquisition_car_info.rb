class AddNotifiersToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :notifiers, :integer, array: true, default: [], comment: "通知谁看"
  end
end
