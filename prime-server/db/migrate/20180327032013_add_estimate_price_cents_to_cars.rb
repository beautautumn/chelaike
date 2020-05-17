class AddEstimatePriceCentsToCars < ActiveRecord::Migration
  def change
    add_column :cars, :estimate_price_cents, :bigint, comment: "车辆估值"
  end
end
