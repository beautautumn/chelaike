class AddIndexToCreatedAtForCars < ActiveRecord::Migration
  def change
    add_index :cars, :created_at
  end
end
