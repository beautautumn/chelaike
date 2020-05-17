class AddReservedToCars < ActiveRecord::Migration
  def change
    add_column :cars, :reserved, :boolean, index: true, default: false, comment: "是否已经预定"
  end
end
