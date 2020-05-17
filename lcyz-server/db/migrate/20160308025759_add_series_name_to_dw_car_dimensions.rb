class AddSeriesNameToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :series_name, :string, index: true, comment: "车系名称"
  end
end
