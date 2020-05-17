class ChangeDisplacementToFloatForCars < ActiveRecord::Migration
  def change
    change_column :cars, :displacement, "float USING CAST(displacement AS float)"
  end
end
