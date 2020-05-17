class AddTotalAmountCentsToDwCarDimensions < ActiveRecord::Migration
  def change
    add_column :dw_car_dimensions, :prepare_items_total_amount_cents, :bigint, comment: "整备费用"
  end
end
