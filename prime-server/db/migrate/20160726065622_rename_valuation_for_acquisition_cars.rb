class RenameValuationForAcquisitionCars < ActiveRecord::Migration
  def change
    rename_column :acquisition_cars, :valuation, :valuation_cents
    rename_column :acquisition_car_comments, :valuation, :valuation_cents
  end
end
