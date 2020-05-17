class DropOldEtlTables < ActiveRecord::Migration
  def change
    drop_table :acquisition_facts
    drop_table :intention_info_dimensions
    drop_table :acquisition_info_dimensions
    drop_table :operation_creation_dimensions
    drop_table :car_dimensions
    drop_table :operation_creation_facts
    drop_table :company_dimensions
    drop_table :out_of_stock_facts
    drop_table :customer_creation_facts
    drop_table :out_stock_info_dimensions
    drop_table :customer_creation_info_dimensions
    drop_table :reservation_facts
    drop_table :intention_creation_facts
    drop_table :reservation_info_dimensions
  end
end
