class AddColumnsToRecommendedCar < ActiveRecord::Migration[5.0]
  def change
    add_column :recommended_cars, :shown_pic_url, :string, after: :car_id
    add_column :recommended_cars, :shown_car_name, :string, after: :car_id
  end
end
