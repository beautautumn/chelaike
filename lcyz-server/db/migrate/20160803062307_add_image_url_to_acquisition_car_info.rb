class AddImageUrlToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :image_url, :string, comment: "车辆图片"
  end
end
