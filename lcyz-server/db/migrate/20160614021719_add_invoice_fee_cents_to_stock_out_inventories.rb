class AddInvoiceFeeCentsToStockOutInventories < ActiveRecord::Migration
  def change
    add_column(:stock_out_inventories, :invoice_fee_cents, :integer, limit: 8, comment: "发票费用")
  end
end
