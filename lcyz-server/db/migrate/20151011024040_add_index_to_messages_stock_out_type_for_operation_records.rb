class AddIndexToMessagesStockOutTypeForOperationRecords < ActiveRecord::Migration
  def change
    execute "CREATE INDEX messages_stock_out_type ON operation_records(cast(\"messages\"->>'stock_out_type' AS char))"
  end
end
