class CreateCarCancelReservations < ActiveRecord::Migration
  def change
    create_table :car_cancel_reservations, comment: "取消预定表" do |t|

      t.integer :car_id, commnet: "所属车辆ID"
      t.boolean :current, default: true, comment: "是否是当前退定"
      t.integer :cancelable_price_cents, limit: 8, comment: "退款金额"
      t.datetime :canceled_at, comment: "退定日期"
      t.string :note, comment: "备注"

      t.timestamps null: false
    end
  end
end
