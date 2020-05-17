class CreateFavoriteCars < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_cars, comment: "收藏车辆" do |t|
      t.integer :wechat_user_id, index: true
      t.integer :car_id, index: true, comment: "车辆 ID"
      t.timestamps
    end
  end
end
