class AddImageUrlToAntQueenRecord < ActiveRecord::Migration
  def change
    add_column :ant_queen_records, :vin_image, :string
  end
end
