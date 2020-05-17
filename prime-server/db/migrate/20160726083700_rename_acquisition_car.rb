class RenameAcquisitionCar < ActiveRecord::Migration
  def change
    rename_table :acquisition_cars, :acquisition_car_infos
    rename_column :acquisition_car_comments, :acquisition_car_id, :acquisition_car_info_id
  end
end
