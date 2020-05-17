class RemoveRedundantIndexs < ActiveRecord::Migration
  def change
    # add_index "cars", ["state", "company_id"], name: "index_cars_on_state_and_company_id", using: :btree
    # add_index "cars", ["state"], name: "index_cars_on_state", using: :btree

    # add_index "operation_records", ["operation_record_type", "created_at"], name: "index_operation_records_on_operation_record_type_and_created_at", using: :btree
    # add_index "operation_records", ["operation_record_type"], name: "index_operation_records_on_operation_record_type", using: :btree


    # add_index "stock_out_inventories", ["car_id", "current", "stock_out_inventory_type"], name: "stock_out_inventories_car_id_current_type", using: :btree
    # add_index "stock_out_inventories", ["car_id", "current"], name: "index_stock_out_inventories_on_car_id_and_current", using: :btree
    # add_index "stock_out_inventories", ["car_id"], name: "index_stock_out_inventories_on_car_id", using: :btree


    # add_index "transfer_records", ["transfer_record_type", "state"], name: "index_transfer_records_on_transfer_record_type_and_state", using: :btree
    # add_index "transfer_records", ["transfer_record_type"], name: "index_transfer_records_on_transfer_record_type", using: :btree

    remove_index :cars, column: :state if index_exists?(:cars, :state)

    remove_index :operation_records, column: :operation_record_type if index_exists?(:operation_records, :operation_record_type)

    remove_index :stock_out_inventories, column: [:car_id, :current] if index_exists?(:stock_out_inventories, [:car_id, :current])
    remove_index :stock_out_inventories, column: :car_id if index_exists?(:stock_out_inventories, :car_id)

    remove_index :transfer_records, column: :transfer_record_type if index_exists?(:transfer_records, :transfer_record_type)
  end
end
