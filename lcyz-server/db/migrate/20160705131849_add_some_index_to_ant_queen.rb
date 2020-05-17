class AddSomeIndexToAntQueen < ActiveRecord::Migration
  def change
    add_index :ant_queen_records, :vin unless index_exists?(:ant_queen_records, :vin)
    add_index :ant_queen_records, :ant_queen_record_hub_id unless index_exists?(:ant_queen_records, :ant_queen_record_hub_id)
    add_index :ant_queen_records, :company_id unless index_exists?(:ant_queen_records, :company_id)
    add_index :ant_queen_records, :car_id unless index_exists?(:ant_queen_records, :car_id)

    add_index :ant_queen_record_hubs, [:vin, :car_brand_id] unless index_exists?(:ant_queen_records, [:vin, :car_brand_id])

    add_index :maintenance_records, :maintenance_record_hub_id unless index_exists?(:maintenance_records, :maintenance_record_hub_id)
    add_index :maintenance_records, :company_id unless index_exists?(:maintenance_records, :company_id)
  end
end
