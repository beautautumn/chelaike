class AddIndexToUpdatedAtForCars < ActiveRecord::Migration
  def change
    add_index :cars, :updated_at
  end
end
