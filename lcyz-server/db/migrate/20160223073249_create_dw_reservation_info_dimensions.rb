class CreateDwReservationInfoDimensions < ActiveRecord::Migration
  def change
    create_table :dw_reservation_info_dimensions, comment: "预定信息维度" do |t|
      t.datetime :reserved_at, comment: "预定时间"
      t.integer :reserved_at_year, comment: "预定时间所在年份"
      t.integer :reserved_at_month, comment: "预定时间所在月份"

      t.timestamps null: false
    end
  end
end
