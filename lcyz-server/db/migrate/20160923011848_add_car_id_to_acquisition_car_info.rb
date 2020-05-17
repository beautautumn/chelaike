class AddCarIdToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :car_id, :integer, comment: "确认收购后关联的在库车辆"
  end
end
