class AddMobileAppCarDetailMenuToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mobile_app_car_detail_menu, :string, array: true, comment: "移动APP车辆详情页菜单"
  end
end
