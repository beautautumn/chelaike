class AddShopIdToOperationRecords < ActiveRecord::Migration
  def change
    add_column :operation_records, :shop_id, :integer, index: true, comment: "店ID"
  end
end
