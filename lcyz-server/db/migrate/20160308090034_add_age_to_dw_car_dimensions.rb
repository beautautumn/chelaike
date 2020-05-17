class AddAgeToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :age, :integer, index: true, comment: "车龄"
  end
end
